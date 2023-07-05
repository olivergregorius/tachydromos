FROM alpine:3.18.2

ARG POSTFIX_VERSION=3.8.1-r0

RUN apk add --update-cache \
    postfix=$POSTFIX_VERSION \
    postfix-ldap=$POSTFIX_VERSION \
    ca-certificates \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

RUN pip3 install jinja2 pyyaml

# Main process must run as root - needs permissions for spawning new processes and binding to ports < 1024
USER root

# SMTP | PROXY procotol | submission
EXPOSE 25 26 587

ENTRYPOINT [""]
CMD [""]
