set -e

# Here comes initial data from mongo
mongorestore \
  --host mongodb \
  --port 27017 \
  --username root \
  --password $MONGO_INITDB_ROOT_PASSWORD \
  --authenticationDatabase admin \
  --drop --gzip \
  --db lecture-calendar \
  --archive=/docker-entrypoint-initdb.d/lecture-calendar.gz