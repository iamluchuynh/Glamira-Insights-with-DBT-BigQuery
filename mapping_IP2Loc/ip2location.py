import logging
from pymongo import MongoClient
import IP2Location
import csv

# Cấu hình logging
logging.basicConfig(
    filename="ip_mapping.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)
logging.info("Starting the IP to Location Mapping script.")

try:
    # Kết nối đến MongoDB
    logging.info("Connecting to MongoDB.")
    client = MongoClient("mongodb://34.87.134.135:27017/", serverSelectionTimeoutMS=20000)
    db = client["Glamira_Data"]
    collection = db["Glamira_Customer_Behavior"]

    # Thiết lập IP2Location
    logging.info("Setting up IP2Location.")
    ip2location_db = IP2Location.IP2Location("IP-COUNTRY-REGION-CITY.BIN")

    # Lấy danh sách IP từ collection
    logging.info("Querying MongoDB for 'view_product_detail' records.")
    unique_ips = set()
    records = collection.find({"collection": "view_product_detail"}, {"ip": 1, "_id": 0})

    # Lọc IP không trùng lặp
    logging.info("Extracting unique IP addresses.")
    for record in records:
        ip = record.get("ip")
        if ip not in unique_ips:
            unique_ips.add(ip)

    logging.info(f"Total unique IPs collected: {len(unique_ips)}")

    # Mapping IPs với thông tin địa lý
    logging.info("Mapping IPs to geographic locations.")
    results = []
    for ip in unique_ips:
        try:
            rec = ip2location_db.get_all(ip)
            location_info = f"{rec.country_short}, {rec.country_long}, {rec.region}, {rec.city}"
            results.append([ip, location_info])
        except Exception as e:
            logging.error(f"Failed to map IP: {ip}. Error: {e}")

    # Ghi dữ liệu ra file CSV
    logging.info("Writing results to CSV file.")
    output_file = "ip_location_mapping.csv"
    with open(output_file, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["IP", "IP-COUNTRY-REGION-CITY"])
        writer.writerows(results)

    logging.info(f"CSV file has been created at: {output_file}")
except Exception as e:
    logging.error(f"An error occurred: {e}")
finally:
    logging.info("Script execution completed.")