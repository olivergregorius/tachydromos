FROM alpine:3.18.2

ARG POSTFIX_VERSION=3.8.1-r0

RUN apk add --update-cache \
    postfix=$POSTFIX_VERSION \
    postfix-ldap=$POSTFIX_VERSION \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Main process must run as root - needs permissions for spawning new processes and binding to ports < 1024
USER root

# SMTP | PROXY procotol | submission
EXPOSE 25 26 587 123

ENTRYPOINT ["/usr/sbin/postfix"]
CMD ["-c", "/etc/postfix", "start-fg"]
