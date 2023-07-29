#!/bin/bash

# AWS S3 Bucket Configuration
S3_BUCKET="your_s3_bucket_name"

# Calculate the date for 10 days ago in the format "YYYY-MM-DD"
DELETE_DATE=$(date +%F -d "10 days ago")

# AWS CLI Configuration
AWS_REGION="your_aws_region"
AWS_ACCESS_KEY_ID="your_aws_access_key_id"         # Replace with your actual AWS access key ID
AWS_SECRET_ACCESS_KEY="your_aws_secret_access_key" # Replace with your actual AWS secret access key

# Output the calculated DELETE_DATE
echo "DELETE_DATE: $DELETE_DATE"

# Configure AWS CLI
echo "Configuring AWS CLI..."
aws configure set region "$AWS_REGION"
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
echo "AWS CLI configured successfully."

# List folders in the root of the S3 bucket
echo "Listing folders in S3 bucket..."
FOLDERS_LIST=$(aws s3 ls "s3://$S3_BUCKET/")

# Output the folders found in the S3 bucket
echo "Found folders:"
echo "$FOLDERS_LIST"

# Loop through the folders and delete those older than 10 days
for folder in $FOLDERS_LIST; do
    folder_date=$(echo "$folder" | sed 's/\///') # Remove the trailing slash

    # Output folder date for each iteration
    echo "Processing folder with date: $folder_date"

    if [[ "$folder_date" < "$DELETE_DATE" ]]; then
        aws s3 rm "s3://$S3_BUCKET/$folder" --recursive

        # Output a message indicating deleted folder
        echo "Deleted folder: $folder"
    fi
done

# Output a message at the end indicating the script is completed
echo "Script completed."
