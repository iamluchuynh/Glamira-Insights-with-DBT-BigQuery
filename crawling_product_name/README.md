# Crawl Product Name from MongoDB

This repository contains a Python script to crawl `product_name` using `product_id` and `current_url` from a MongoDB database. This script is part of a larger project aimed at transforming customer behavior data on the Glamira website into actionable insights. The project involves processing 40 million data records, and this script plays a critical role in extracting product names.

## Features

- Connects to a MongoDB database to fetch customer behavior data.
- Crawls product names from URLs using asynchronous HTTP requests.
- Supports concurrent requests to speed up data crawling.
- Handles failed requests and logs errors for debugging.
- Outputs results in a CSV file for further analysis.

## Requirements

- Python 3.8+
- MongoDB server
- The following Python libraries:
  - `aiohttp`
  - `asyncio`
  - `beautifulsoup4`
  - `motor`
  - `csv`
  - `logging`
  - `gc`
  - `os`

## Installation

1. Clone this repository:

   ```bash
   git clone <repository_url>
   cd <repository_folder>
   ```

2. Install the required dependencies:

   ```bash
   pip install aiohttp beautifulsoup4 motor
   ```

3. Configure MongoDB connection details in the script:

   ```python
   MONGO_URI = "mongodb://<your-mongodb-uri>"
   DB_NAME = "Glamira_Data"
   COLLECTION_NAME = "Glamira_Customer_Behavior"
   TARGET_COLLECTIONS = ["view_product_detail", "select_product_option", "select_product_option_quality"]
   ```

4. Set up output files:

   - `product_name_data.csv`: Stores the output data.
   - `processed_product_ids.txt`: Tracks processed product IDs to prevent duplicate processing.
   - `crawl_log.log`: Logs errors and warnings.

## Usage

1. Run the script:

   ```bash
   python crawling_names.py
   ```

2. The script will:

   - Connect to the MongoDB database and fetch records with `product_id` and `current_url` fields.
   - Crawl the product names by visiting the `current_url`.
   - Save the `product_id`, `product_name`, and `current_url` to `product_name_data.csv`.

## Script Details

### Key Components

- **MongoDB Connection**:
  Uses `motor` to establish an asynchronous connection to the MongoDB database.

- **HTTP Requests**:
  Uses `aiohttp` for making asynchronous requests to product URLs.

- **HTML Parsing**:
  Uses `BeautifulSoup` to extract product names from the HTML content of the URLs.

- **Concurrency**:
  Implements a semaphore to limit the number of concurrent requests and uses asyncio queues for efficient task distribution.

- **Error Handling**:
  Logs errors (e.g., HTTP failures, missing product names) to `crawl_log.log` for review.

### Constants

| Constant                  | Description                                  |
| ------------------------- | -------------------------------------------- |
| `MONGO_URI`               | URI for MongoDB connection.                  |
| `DB_NAME`                 | Name of the database.                        |
| `COLLECTION_NAME`         | Name of the main collection to query.        |
| `TARGET_COLLECTIONS`      | Specific sub-collections to fetch data from. |
| `OUTPUT_CSV`              | File to store crawled data.                  |
| `PROCESSED_IDS_FILE`      | File to track processed product IDs.         |
| `LOG_FILE`                | Log file for errors and warnings.            |
| `MAX_CONCURRENT_REQUESTS` | Maximum number of concurrent HTTP requests.  |

### Functions

- `fetch_url`: Fetches HTML content from a given URL.
- `process_content`: Extracts the product name using multiple parsing methods.
- `process_record`: Processes individual database records and writes results to the output file.
- `main`: Coordinates the data fetching and processing tasks.

## Output

- `product_name_data.csv`: Contains columns:

  - `product_id`
  - `product_name`
  - `current_url`

- Logs errors and warnings in `crawl_log.log`.

## Notes

- Ensure the MongoDB server is running and accessible.
- Update the `MONGO_URI` constant with the correct MongoDB connection string.
- If the script is interrupted, it can resume by referencing `processed_product_ids.txt`.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributions

Contributions are welcome! Please submit issues and pull requests for improvements.

## Contact

For inquiries, please contact [[huynhluc2910@gmail.com](mailto\:your-email@example.com)].

