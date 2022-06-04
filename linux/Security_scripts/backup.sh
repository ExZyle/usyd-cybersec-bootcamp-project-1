#!/usr/bin/env bash

BACKUP_FOLDER=/var/backup

mkdir -p /var/backup $BACKUP_FOLDER
tar czf $BACKUP_FOLDER/home.tgz /home

# Move archive
mv /var/backup/home.tar /var/backup/home.29032022.tgz

# List fils in the backup folder
ls -lh /var/backup > /var/backup/file_report.txt

free -h > /var/backup/disk_report.txt
