# Qemu Installation to convert disk images
# 
# VERSION 0.0.1 
# 
# 0.0.1 : initial creation of image

FROM debian:jessie 

MAINTAINER Robert Reihs <robert.reihs@gmail.com>

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install qemu-utils \
    && rm -rf /var/lib/apt/lists/*
    
ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

#ENTRYPOINT ["/opt/scripts/entrypoint.sh"]