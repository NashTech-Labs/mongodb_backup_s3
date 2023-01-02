#!/bin/bash

# Set the current date and time in the format YYYY-MM-DD-HH-MM
DATE=$(date +"%Y-%m-%d-%H-%M")

# Set the name of the database that you want to backup
DATABASE_NAME=mydatabase

# Set the name of the S3 bucket where you want to store the backup
S3_BUCKET=my-s3-bucket

# Set the path to the directory where you want to store the backup
BACKUP_DIR=/var/backups/mongodb

# Set the path to the MongoDB dump utility
MONGODUMP_PATH=/usr/bin/mongodump

# Set the path to the AWS CLI
AWS_CLI_PATH=/usr/local/bin/aws

# Create the backup directory if it does not already exist
mkdir -p $BACKUP_DIR

# Take the MongoDB backup
$MONGODUMP_PATH -d $DATABASE_NAME -o $BACKUP_DIR

# Compress the backup directory into a .tar.gz file
tar -czvf $BACKUP_DIR/$DATABASE_NAME-$DATE.tar.gz -C $BACKUP_DIR .

# Upload the backup file to S3
$AWS_CLI_PATH s3 cp $BACKUP_DIR/$DATABASE_NAME-$DATE.tar.gz s3://$S3_BUCKET/$DATABASE_NAME-$DATE.tar.gz

# Remove the backup file and directory
rm -rf $BACKUP_DIR/$DATABASE_NAME-$DATE.tar.gz $BACKUP_DIR/dump