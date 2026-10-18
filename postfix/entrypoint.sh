#!/bin/sh
set -e

syslogd -O /dev/stdout &

envsubst '$MAIL_HOSTNAME $MAIL_DOMAIN' < /etc/postfix/main.cf.template > /etc/postfix/main.cf

for f in /etc/postfix/pgsql-*.cf.template; do
  envsubst '$DB_HOST $DB_USER $DB_PASSWORD $DB_NAME' < "$f" > "${f%.template}"
done

chmod 0644 /etc/postfix/main.cf /etc/postfix/master.cf
chmod 0600 /etc/postfix/pgsql-*.cf

postfix check || true
newaliases || true

exec postfix start-fg
