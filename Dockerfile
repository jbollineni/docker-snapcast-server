FROM alpine:edge

MAINTAINER Jana Bollineni (jana.bollineni@gmail.com)

LABEL version="1.2"
LABEL org.label-schema.name="Snapcast Server Docker" \
      org.label-schema.description="Snapcast server on alpine image with Avahi and D-Bus support" \
      org.label-schema.schema-version="1.0"

RUN apk -U add snapcast-server \
    && apk add avahi \
    && apk add dbus \
    && dbus-uuidgen > /var/lib/dbus/machine-id \
    && mkdir -p /var/run/dbus \
    && mkdir -p /tmp/snapcast/ \
    && rm -rf /etc/ssl /var/cache/apk/* /lib/apk/db/*

CMD rm /var/run/dbus.pid; dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address; avahi-daemon -D; snapserver
