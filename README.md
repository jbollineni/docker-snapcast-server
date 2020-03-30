# Snapcast Server

Docker image of Snapcast server with Avahi support

## Dockerfile

~~~ go
FROM alpine:edge

LABEL version="1.2"
LABEL org.label-schema.name="Snapcast Server Docker" \
	  org.label-schema.description="Snapcast server on alpine image with Avahi and D-Bus support" \
	  org.label-schema.schema-version="1.0"

RUN apk -U add snapcast-server \
	&& mkdir -p /tmp/snapcast/
	&& mkfifo /tmp/snapcast/fifo \
	&& apk add -U avahi \
	&& apk add dbus \
	&& dbus-uuidgen > /var/lib/dbus/machine-id \
	&& mkdir -p /var/run/dbus \
	&& dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address \
	&& rm -rf /etc/ssl /var/cache/apk/* /lib/apk/db/* 
	
ENTRYPOINT ["avahi-daemon -D", "snapserver --config=/etc/snapserver.conf"]
~~~

## Examples

Docker command:
~~~ go
docker run -d \
	--net=host \
    -v /tmp/snapcast/fifo:/tmp/snapcast/fifo \
	-v /opt/snapserver/snapserver.conf:/etc/snapserver.conf \
	jbollineni/snapcast-server
~~~

/opt/snapserver/snapserver.conf contents:
~~~ go
[stream]
stream = pipe:///tmp/snapcast/fifo?name=Snapcast&sampleformat=44100:16:2
~~~


