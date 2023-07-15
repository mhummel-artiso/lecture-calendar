set -e

mongosh <<EOF
use lecture-calendar;
db.createUser({
  user: 'calendar',
  pwd: '$CALENDAR_PASSWORD',
  roles: [{ role: 'readWrite', db: 'lecture-calendar' }],
});
db.createCollection('calendar')
EOF