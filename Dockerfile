FROM httpd:2.4

VOLUME ["/etc/httpd/conf/certs"]

ENV AUTHOR_ENV_TUTUM_SERVICE_FQDN ''
ENV PUBLISH_ENV_TUTUM_SERVICE_FQDN ''
ENV AUTHOR_PORT_4502_TCP_PORT ''
ENV PUBLISH_PORT_4503_TCP_PORT ''

ENV DISPATCHER_VERSION 4.1.11
ENV DISPATCHER_GZ_URL https://www.adobeaemcloud.com/content/companies/public/adobe/dispatcher/dispatcher/_jcr_content/top/download_10/file.res/dispatcher-apache2.4-linux-x86-64-$DISPATCHER_VERSION.tar.gz

RUN buildDeps='ca-certificates curl' set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& rm -r /var/lib/apt/lists/* \
	&& curl -SL "$DISPATCHER_GZ_URL" -o dispatcher.tar.gz \
	&& mkdir -p src/dispatcher \
	&& tar -xvf dispatcher.tar.gz -C src/dispatcher \
	&& rm dispatcher.tar.gz* \
	&& cp src/dispatcher/dispatcher-apache2.4-$DISPATCHER_VERSION.so $HTTPD_PREFIX/modules/mod_dispatcher.so \
	&& rm -r src/dispatcher \
	&& apt-get purge -y --auto-remove $buildDeps

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./dispatcher.any /usr/local/apache2/conf/dispatcher.any
