FROM alpine:3.19

RUN apk add --no-cache postfix postfix-pgsql bash cyrus-sasl gettext

COPY main.cf.template /etc/postfix/main.cf.template
COPY master.cf /etc/postfix/master.cf
COPY pgsql-virtual-domains.cf.template /etc/postfix/pgsql-virtual-domains.cf.template
COPY pgsql-virtual-mailboxes.cf.template /etc/postfix/pgsql-virtual-mailboxes.cf.template
COPY pgsql-virtual-aliases.cf.template /etc/postfix/pgsql-virtual-aliases.cf.template

COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 25 465 587

ENTRYPOINT ["/entrypoint.sh"]
