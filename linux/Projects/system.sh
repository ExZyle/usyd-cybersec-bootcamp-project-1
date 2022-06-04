#!/bin/bash

# The question didn't ask  for this, however the bonus question, moving to the weekly cron directory,
# will cause the script to break since it will be run as root, not as the sysadmin user.
# Two ways to stop it breaking (both included here):
# 1 Use an absolute bath for the directory, not user relative. You would need to change BASE_DIRECTORY
#   to be specific: BASE_DIRECTORY=/home/sysadmin/backups
# 2 Create the output directories if they don't exist (see next code block)
BASE_DIRECTORY=~/backups
#BASE_DIRECTORY=/home/sysadmin/backups

# Create the directories if they don't exist:
# The question didn't ask  for this, however the bonus question, moving to the weekly cron directory,
# will cause the script to break since it will be run as root, not as the sysadmin user, and the directories
# may not already exist for the root user
mkdir -p $BASE_DIRECTORY/{freemem,diskuse,openlist,freedisk}

# Prints the amount of free memory on the system and saves it to ~/backups/freemem/free_mem.txt.
free -h > $BASE_DIRECTORY/freemem/free_mem.txt

# Prints disk usage and saves it to ~/backups/diskuse/disk_usage.txt.
df -h --output=source,used,target > $BASE_DIRECTORY/diskuse/disk_usage.txt # Outputs only the disk usage information

# Lists all open files and saves it to ~/backups/openlist/open_list.txt.
lsof > $BASE_DIRECTORY/openlist/open_list.txt

# Prints file system disk space statistics and saves it to ~/backups/freedisk/free_disk.txt.
# This question is confusing, it asks for "disk space statistics", however the output file is called "free_disk.txt"
# The name of the file implies it should be the free disk space, not disk space statistics.
#
# Since "Disk Space Statistics" includes free space, I will outputing the requested "Disk Space Statistics"
# to the required "free_disk.txt" file. Thank you
df -h > $BASE_DIRECTORY/diskuse/free_disk.txt # Outputs all disk space statistics as requested
