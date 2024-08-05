import csv
import os
import requests
import concurrent.futures

# Define the endpoint URL
endpoint_url = "http://localhost:8080/v1/qrcodetypes/scan" 

# Path to the CSV file
csv_file_path = "malicious_phish.csv"

# Directory to store the split CSV files
split_files_dir = "split_csv_files"
os.makedirs(split_files_dir, exist_ok=True)

# Function to ensure URL starts with http:// or https://
def ensure_url_prefix(url):
    if not (url.startswith("http://") or url.startswith("https://")):
        return "https://" + url
    return url

# Read the CSV file and split into 20 files
def split_csv_file(csv_file_path, split_files_dir, num_splits=20):
    with open(csv_file_path, newline='') as csvfile:
        reader = list(csv.DictReader(csvfile))
        total_rows = len(reader)
        rows_per_file = total_rows // num_splits
        
        for i in range(num_splits):
            split_file_path = os.path.join(split_files_dir, f"split_file_{i+1}.csv")
            with open(split_file_path, 'w', newline='') as split_file:
                writer = csv.DictWriter(split_file, fieldnames=['url', 'type'])
                writer.writeheader()
                start_index = i * rows_per_file
                end_index = (i + 1) * rows_per_file if i != num_splits - 1 else total_rows
                for row in reader[start_index:end_index]:
                    row['url'] = ensure_url_prefix(row['url'])
                    writer.writerow(row)

# Function to process a CSV file and send POST requests
def process_csv_file(csv_file_path):
    with open(csv_file_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            url = row['url']  # Column header for URL is 'url'
            response = requests.post(endpoint_url, json={"data": url})
            if response.status_code == 200:
                print(f"Successfully sent data: {url}")
            else:
                print(f"Failed to send data: {url}, Status code: {response.status_code}")

# Split the original CSV file into 20 parts
split_csv_file(csv_file_path, split_files_dir)

# Get the list of split CSV files
split_files = [os.path.join(split_files_dir, file) for file in os.listdir(split_files_dir) if file.endswith('.csv')]

# Execute the requests concurrently
with concurrent.futures.ThreadPoolExecutor(max_workers=20) as executor:
    futures = [executor.submit(process_csv_file, split_file) for split_file in split_files]
    concurrent.futures.wait(futures)

print("Processing completed.")
