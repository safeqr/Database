# Project Repository

This repository contains various components essential for setting up and running a backend service. The components include database schema scripts, serverless Lambda functions, and API Gateway configuration files. Below are the details on each component and how to set up the PostgreSQL database.

## Repository Structure

- **/apigw/**: Contains the backup configuration file for the API Gateway.
- **/dataset/**: Includes datasets and scripts related to data processing.
  - `malicious_phish.csv`: A CSV file containing data related to malicious phishing links.
  - `load_data.py`: A Python script for loading data into the database.
- **/gmail-json/**: JSON files containing configurations or sample data for Gmail-related processing.
- **/serverless/**: Contains the serverless Lambda function scripts.
  - `safeqr-signup-post-confirmation`: A script for the Lambda function that handles post-signup confirmation in the SafeQR service.
- **/sql/**: SQL scripts for setting up and managing the PostgreSQL database.
  - `Create_all_tables.sql`: Script to create all necessary tables.
  - `Drop_all_tables.sql`: Script to drop all tables.
  - `Dummy_data.sql`: Script to insert dummy data into the tables.
  - `qr_code_types_202408032138.sql`: Script to set up QR code types.
- **.gitignore**: Specifies files and directories to be ignored by Git.
- **README.md**: This file, providing an overview and setup instructions for the repository.

## Prerequisites

Before setting up the components in this repository, ensure you have the following installed:

- **PostgreSQL**: The database system required for managing and storing the data.
- **Python 3.7+**: Needed for running any Python scripts in the repository.
- **AWS CLI**: For deploying serverless functions and managing AWS resources.
- **Java 17**: Required if any part of the system uses Java-based components.

## Setting Up the PostgreSQL Database

To install PostgreSQL and set up the database using the provided SQL scripts, follow the steps below:

### 1. Install PostgreSQL

For macOS users:

```bash
brew install postgresql
brew services start postgresql
```

For Ubuntu users:

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

### 2. Access PostgreSQL and Create a Database

Access the PostgreSQL command line:

```bash
psql postgres
```

Create a new database:

```sql
CREATE DATABASE safeqr;
```

### 3. Run the SQL Scripts

Navigate to the `/sql/` directory and run the provided scripts to set up your database schema and populate it with dummy data:

```bash
psql -d safeqr -f Create_all_tables.sql
psql -d safeqr -f Dummy_data.sql
```

### 4. Verifying the Database Setup

Ensure that all tables are correctly created and populated with data by accessing the database:

```bash
psql -d safeqr
```

Then, you can list tables or query data to verify:

```sql
\dt
SELECT * FROM your_table_name LIMIT 10;
```

## Serverless Lambda Function

The `/serverless/` directory contains scripts for AWS Lambda functions. Ensure that you have the AWS CLI set up with the necessary permissions to deploy and manage Lambda functions.

### Deploying the Lambda Function

Navigate to the `/serverless/` directory and deploy the function:

```bash
aws lambda update-function-code --function-name your_function_name --zip-file fileb://path_to_your_zip_file.zip
```

## API Gateway Configuration

The `/apigw/` directory contains a backup of the API Gateway configuration. This can be used to restore or update the API Gateway setup in AWS.

### Restoring API Gateway

Use the AWS CLI to restore the API Gateway configuration:

```bash
aws apigateway import-rest-api --body 'file://path_to_your_swagger_file.json'
```

## Conclusion

This repository provides all the necessary components to set up the backend infrastructure, including database setup, serverless Lambda functions, and API Gateway configurations. Follow the instructions carefully to get everything up and running. For any issues, please refer to the documentation or raise an issue in the repository.
