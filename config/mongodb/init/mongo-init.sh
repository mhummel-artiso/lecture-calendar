set -e

# Here comes initial data from mongo
mongosh <<EOF
use lecture-calendar;
db.createCollection('events')
db.createCollection('lectures')
EOF