FROM debian:buster

VOLUME /var/lib/clamav

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates clamav-daemon clamav-freshclam wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY init /sbin/

ENTRYPOINT ["/sbin/init"]
