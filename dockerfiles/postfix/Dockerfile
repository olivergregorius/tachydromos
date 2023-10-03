FROM alpine:3.18.3

ARG APPVERSION

RUN apk add --update-cache \
    postfix=$APPVERSION \
    postfix-ldap=$APPVERSION \
    ca-certificates \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

RUN pip3 install jinja2 pyyaml

# Main process must run as root - needs permissions for templating config files, spawning new processes and binding to ports < 1024
USER root

# SMTP | PROXY procotol | Submission
EXPOSE 25 26 587

ENTRYPOINT []
CMD []
