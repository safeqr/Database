import csv
import requests

# Define the endpoint URL
endpoint_url = "http://localhost:8080/v1/qrcodetypes/scan" 

# Path to the CSV file
csv_file_path = "malicious_phish.csv" 

# Function to ensure URL starts with http:// or https://
def ensure_url_prefix(url):
    if not (url.startswith("http://") or url.startswith("https://")):
        return "https://" + url
    return url

# Read the CSV file, prefix URLs, and send POST requests
with open(csv_file_path, newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        url = row['url'] 
        url_with_prefix = ensure_url_prefix(url)
        response = requests.post(endpoint_url, json={"data": url_with_prefix})
        
        if response.status_code == 200:
            print(f"Successfully sent data: {url_with_prefix}")
        else:
            print(f"Failed to send data: {url_with_prefix}, Status code: {response.status_code}")