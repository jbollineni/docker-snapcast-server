FROM alpine:edge

LABEL org.label-schema.name="Snapcast Server Docker" \
	  org.label-schema.description="Snapcast server and Avahi on alpine image" \
	  org.label-schema.schema-version="1.0"

RUN apk -U add snapcast-server \
	&& mkdir -p /tmp/snapcast/ \
	&& mkfifo /tmp/snapcast/fifo \
	&& apk add -U avahi \
	&& sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf \
    && avahi-daemon -D \
	&& rm -rf /etc/ssl /var/cache/apk/* /lib/apk/db/* 
	
CMD snapserver --config=/etc/snapserver.conf