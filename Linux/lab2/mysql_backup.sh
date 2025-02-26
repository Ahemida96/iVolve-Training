#!/bin/bash

# Where to backup to.
backup_location="/mnt/DB-backup"
[ ! -d $backup_location ] && mkdir $backup_location

# Print start status message.
echo "Backing up to $backup_location"
date
echo

day=$(date +%F)
mysqldump -u root -proot--all-databases > "$backup_location/mysql-$day"

# Print end status message.
echo
echo "Backup finished"
date
