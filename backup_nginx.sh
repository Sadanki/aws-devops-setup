#!/bin/bash

# Variables
BACKUP_DIR="/backups"
TIMESTAMP=$(date +%F)
BACKUP_FILE="$BACKUP_DIR/nginx_backup_$TIMESTAMP.tar.gz"
NGINX_CONFIG="/etc/nginx/"
NGINX_WEBROOT="/usr/share/nginx/html/"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform backup
tar -czf "$BACKUP_FILE" "$NGINX_CONFIG" "$NGINX_WEBROOT"

# Verify backup integrity
tar -tzf "$BACKUP_FILE" > /dev/null

if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Backup failed!"
    exit 1
fi
