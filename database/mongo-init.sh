set -e

mongosh <<EOF
use calendar;
db.createUser({
  user: 'calendar',
  pwd: '$CALENDAR_PASSWORD',
  roles: [{ role: 'readWrite', db: 'calendar' }],
});
EOF