# OpenLDAP 
# 
# VERSION 0.0.1 
# 
# 0.0.1 : initial creation of image with OpenLdap based von debian:jessie

FROM debian:jessie 

MAINTAINER Robert Reihs <robert.reihs@gmail.com>

COPY setup.sh /setup.sh
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update \
    && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y slapd \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ldap-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /setup.sh \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["slapd", "-d", "32768", "-u", "openldap", "-g", "openldap"]