#!/bin/sh
set -e

envsubst < /etc/dovecot/dovecot-sql.conf.ext.template > /etc/dovecot/dovecot-sql.conf.ext
envsubst < /etc/dovecot/dovecot.conf.template > /etc/dovecot/dovecot.conf

chmod 0600 /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot.conf

exec dovecot -F
