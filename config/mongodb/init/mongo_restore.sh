#!/bin/bash
# Restore from dump

docker exec -i lecture-calendar-mongodb-1 /usr/bin/mongorestore --host mongodb --port 27017 --username root --password '74RuqICjDPQEFREmhIFaqRf6H' --authenticationDatabase admin --drop --gzip --db lecture-calendar --archive=/backup_data/lecture-calendar.gz
