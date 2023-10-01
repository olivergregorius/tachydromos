FROM alpine:3.18.3

ARG APPVERSION

RUN apk add --update-cache \
    dovecot=$APPVERSION \
    dovecot-lmtpd=$APPVERSION \
    dovecot-ldap=$APPVERSION \
    dovecot-pigeonhole-plugin=$APPVERSION \
    msmtp \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

RUN pip3 install jinja2 pyyaml \
    && addgroup -g 5000 -S vmail \
    && adduser -u 5000 -h /srv/dovecot -G vmail -S vmail \
    && rm -r /etc/dovecot/conf.d/*

# Main process must run as root - needs permissions for spawning new processes and binding to ports < 1024
USER root

# LMTP | IMAP | SASL | Sieve
EXPOSE 24 143 3659 4190

ENTRYPOINT []
CMD []
