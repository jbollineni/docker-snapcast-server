# Snapcast Server

Docker image of Snapcast server with Avahi support

## Dockerfile

~~~ go
FROM alpine:edge

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="Snapcast Server Docker" \
	  org.label-schema.description="Snapcast server and Avahi on alpine image" \
	  org.label-schema.url="" \
	  org.label-schema.vcs-ref=$VCS_REF \
	  org.label-schema.vcs-url="" \
	  org.label-schema.vendor="" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.schema-version="1.0"

RUN apk -U add snapcast-server \
	&& mkdir -p /tmp/snapcast/
	&& mkfifo /tmp/snapcast/fifo
	&& apk add -U avahi
	&& sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf
	&& rm -rf /etc/ssl /var/cache/apk/* /lib/apk/db/* 
	
CMD snapserver --config=/etc/snapserver.conf

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


