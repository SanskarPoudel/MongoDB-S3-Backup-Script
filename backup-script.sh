#!/bin/bash

# MongoDB Configuration
MONGO_HOST="your_mongo_host"
MONGO_PORT="your_mongo_port"
DATABASE_NAME="your_database_name"
MONGO_USERNAME="your_mongo_username"
MONGO_PASSWORD="your_mongo_password"
MONGO_SSL="--ssl" # Enable SSL connection, add --sslCAFile, --sslPEMKeyFile, etc. if needed

# Backup Directory (local)
BACKUP_DIR="/backup"

# Path to the .pem file
PEM_FILE="PATH_TO_PEM_FILE"

# Get current date (YYYY-MM-DD format)
CURRENT_DATE=$(date +%F)

# Backup MongoDB
mongodump --host "$MONGO_HOST" --port "$MONGO_PORT" --db "$DATABASE_NAME" --username "$MONGO_USERNAME" --password "$MONGO_PASSWORD" "$MONGO_SSL" --sslPEMKeyFile "$PEM_FILE" --sslAllowInvalidCertificates --out "$BACKUP_DIR/$CURRENT_DATE" //MODIFY ACCORDING TO YOUR NEEDS

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "MongoDB backup successful."
else
    echo "MongoDB backup failed. Exiting script."
    exit 1
fi

# S3 Bucket Configuration
S3_BUCKET="your_s3_bucket"
S3_BACKUP_FOLDER="your_s3_backup_folder"

# AWS CLI Configuration
AWS_REGION="your_aws_region"
AWS_ACCESS_KEY_ID="your_aws_access_key_id"         # Replace with your actual AWS access key ID
AWS_SECRET_ACCESS_KEY="your_aws_secret_access_key" # Replace with your actual AWS secret access key

# Configure AWS CLI
aws configure set region "$AWS_REGION"
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"

# Upload Backup to S3 Bucket
aws s3 cp "$BACKUP_DIR/$CURRENT_DATE" "s3://$S3_BUCKET/$S3_BACKUP_FOLDER/$CURRENT_DATE" --recursive

# Check if upload was successful
if [ $? -eq 0 ]; then
    echo "Backup uploaded to S3 bucket successfully."
else
    echo "Backup upload to S3 bucket failed. Exiting script."
    exit 1
fi

echo "Backup process completed."
