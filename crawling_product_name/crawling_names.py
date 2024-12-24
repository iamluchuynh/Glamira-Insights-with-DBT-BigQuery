import asyncio
import aiohttp
from bs4 import BeautifulSoup
from motor.motor_asyncio import AsyncIOMotorClient
import csv
import logging
import json
import os
import gc

# Constants
MONGO_URI = "mongodb://34.143.141.34:27017"
DB_NAME = "Glamira_Data"
COLLECTION_NAME = "Glamira_Customer_Behavior"
TARGET_COLLECTIONS = ["view_product_detail", "select_product_option", "select_product_option_quality"]
OUTPUT_CSV = "product_name_data.csv"
PROCESSED_IDS_FILE = "processed_product_ids.txt"
LOG_FILE = "crawl_log.log"
MAX_CONCURRENT_REQUESTS = 35

# Set up logging
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.ERROR,
    format='%(asctime)s %(levelname)s:%(message)s'
)

async def fetch_url(session, url, product_id):
    if not url.startswith(('http://', 'https://')):
        url = 'https://' + url

    try:
        async with session.get(url) as response:
            logging.info(f"Status: {response.status}, URL: {response.url}")
            if response.status == 200 and "checkout/cart" not in str(response.url):
                return await response.text(), str(response.url)
            else:
                logging.warning(f"Failed to fetch {url} with status: {response.status}")
    except aiohttp.ClientError as e:
        logging.error(f"Error connecting to {url}: {e}")
    return None, url

async def process_content(content, product_id, url):
    soup = BeautifulSoup(content, "html.parser")
    name = None
    methods = [
        lambda: soup.find('span', class_='base').text,
        lambda: next((span.text for infor in soup.find_all("div", class_=["info_stone", "info_stone_total"])
                      for product_item_detail in [soup.find("h2", class_=["product-item-details", "product-name"])]
                      for span in [product_item_detail.find("span", "hide-on-mobile")]
                      if json.loads(infor.find("p", class_=["enable-popover", "popover_stone_info"])["data-ajax-data"]).get("product_id") == product_id), None),
        lambda: soup.find("div", class_="product-info-desc").find("h1").text
    ]
    for method in methods:
        try:
            name = method()
            if name:
                break
        except (AttributeError, TypeError):
            continue
    if name:
        return name
    else:
        logging.warning(f"No product name found for {url}")
        return None

async def process_record(semaphore, session, record, processed_ids_set, output_lock):
    product_id = str(record.get('product_id'))
    url = record.get('current_url', '').strip()

    if not url:
        logging.warning(f"Invalid URL for product_id {product_id}")
        return

    async with output_lock:
        if product_id in processed_ids_set:
            logging.info(f"Skipping already processed product_id {product_id}")
            return
        processed_ids_set.add(product_id)

    async with semaphore:
        content, final_url = await fetch_url(session, url, product_id)
        if content:
            name = await process_content(content, product_id, final_url)
            if name:
                async with output_lock:
                    with open(OUTPUT_CSV, 'a', newline='', encoding='utf-8') as csvfile:
                        writer = csv.writer(csvfile)
                        writer.writerow([product_id, name, final_url])
                    with open(PROCESSED_IDS_FILE, 'a') as pid_file:
                        pid_file.write(f"{product_id}\n")
            else:
                logging.warning(f"Product name not found for product_id {product_id}")
        else:
            logging.error(f"Failed to fetch content for product_id {product_id}")
        
        # Giải phóng bộ nhớ
        del content, final_url  # Xóa các biến lớn
        gc.collect()  # Gọi bộ thu gom rác
        await asyncio.sleep(2)

async def main():
    client = AsyncIOMotorClient(MONGO_URI)
    db = client[DB_NAME]
    collection = db[COLLECTION_NAME]

    semaphore = asyncio.Semaphore(MAX_CONCURRENT_REQUESTS)
    output_lock = asyncio.Lock()
    processed_ids_set = set()

    if os.path.exists(PROCESSED_IDS_FILE):
        with open(PROCESSED_IDS_FILE, 'r') as pid_file:
            processed_ids_set = set(line.strip() for line in pid_file)

    if not os.path.exists(OUTPUT_CSV):
        with open(OUTPUT_CSV, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['product_id', 'product_name', 'current_url'])

    cursor = collection.find({"collection": {"$in": TARGET_COLLECTIONS}}, {"product_id": 1, "current_url": 1})

    queue = asyncio.Queue()

    # Hàm fetch dữ liệu từ MongoDB và đưa vào hàng đợi
    async def fetch_data_from_db():
        async for record in cursor:
            await queue.put(record)
        for _ in range(MAX_CONCURRENT_REQUESTS):
            await queue.put(None)

    # Hàm xử lý dữ liệu từ hàng đợi
    async def data_processor():
        connector = aiohttp.TCPConnector(limit=50)
        async with aiohttp.ClientSession(connector=connector) as session:
            while True:
                record = await queue.get()
                if record is None:
                    break
                await process_record(semaphore, session, record, processed_ids_set, output_lock)
        connector.close()  # Đóng kết nối HTTP khi xong

    # Tạo các coroutine chính
    producer_task = asyncio.create_task(fetch_data_from_db())
    consumer_tasks = [asyncio.create_task(data_processor()) for _ in range(MAX_CONCURRENT_REQUESTS)]

    # Chờ các coroutine hoàn thành
    await producer_task
    await asyncio.gather(*consumer_tasks)

if __name__ == "__main__":
    asyncio.run(main())
