FROM alpine:3.19

RUN apk add --no-cache dovecot dovecot-pgsql dovecot-lmtpd bash gettext

RUN addgroup -g 1000 vmail && \
    adduser -u 1000 -G vmail -s /bin/false -D vmail && \
    mkdir -p /var/vmail && \
    chown -R vmail:vmail /var/vmail

COPY dovecot.conf.template /etc/dovecot/dovecot.conf.template
COPY dovecot-sql.conf.ext.template /etc/dovecot/dovecot-sql.conf.ext.template

COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 143 993

ENTRYPOINT ["/entrypoint.sh"]
