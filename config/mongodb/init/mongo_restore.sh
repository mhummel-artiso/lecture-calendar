#!/bin/bash
# WARNING: only use \n (LF) instead of \r\n (CRLF) becouse file not work
# Restore from dump
echo Initial database from archive
ls /backup_data/
echo MONGO_INITDB_DATABASE=$MONGO_INITDB_DATABASE
mongorestore --username root --password $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin \
  --drop --gzip --db=$MONGO_INITDB_DATABASE --archive=/backup_data/lecture-calendar.gz
