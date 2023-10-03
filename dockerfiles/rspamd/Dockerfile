FROM alpine:3.18.3

ARG APPVERSION

RUN apk add --update-cache \
    rspamd=$APPVERSION \
    rspamd-controller=$APPVERSION \
    rspamd-proxy=$APPVERSION \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

RUN pip3 install jinja2 pyyaml

# Main process must run as root - needs permissions for templating config files and spawning new processes
USER root

# Milter | Webinterface
EXPOSE 11332 11334

ENTRYPOINT []
CMD []
