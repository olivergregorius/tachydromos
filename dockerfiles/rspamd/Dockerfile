FROM alpine:3.18.2

ARG RSPAMD_VERSION=3.5-r7

RUN apk add --update-cache \
    rspamd=$RSPAMD_VERSION \
    rspamd-controller=$RSPAMD_VERSION \
    rspamd-proxy=$RSPAMD_VERSION \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

RUN pip3 install jinja2 pyyaml

# Main process must run as root - needs permissions for spawning new processes and binding to ports < 1024
USER root

# Milter | Webinterface
EXPOSE 11332 11334

ENTRYPOINT []
CMD []
