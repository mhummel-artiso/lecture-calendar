#!/bin/bash
# Restore from dump

mongorestore --host mongodb --port 27017 --username root --password $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin --drop --gzip --db lecture-calendar --archive=/backup_data/lecture-calendar.gz