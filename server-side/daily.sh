#!/bin/bash

# The backup directory
BACKUP_DIR='/media/storage/backup'

# Find the previous day to take daily backups from hourly backups done on that day
PREV_DAY=$(perl -e 'use POSIX;print strftime "%Y-%m-%d",localtime time-86400;')
echo Previous day: $PREV_DAY

# The directory to use for daily backups. Format: YYYY-MM-DD
DAILY_DIR=$BACKUP_DIR/$PREV_DAY
echo Creating directory $DAILY_DIR
mkdir -p "$DAILY_DIR"

# Get the list of hourly backup directories to be used for daily backups
DIR_LIST=$(ls -d ${BACKUP_DIR}/${PREV_DAY}_* 2>/dev/null)
echo $DIR_LIST

# Rsync the contents of the hourly backup directories to the daily
# backup directories starting from the older backup to the newer
# backup. This way the daily backup will have the up-to-date files
# as of 11 PM on that day.
for dir in $DIR_LIST; do
  echo "Rsyncinc $dir to $DAILY_DIR"
  rsync -r $dir/* $DAILY_DIR
  echo "Removing $dir"
  rm -rf $dir
done
