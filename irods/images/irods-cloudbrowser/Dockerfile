# iRODS Cloud Browser
# 
# VERSION 0.0.1 
# 
# 0.0.1 : initial creation of image for iRODS Cloud Browser

FROM debian:jessie 

MAINTAINER Robert Reihs <robert.reihs@gmail.com>

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install tomcat7 tomcat7-docs tomcat7-admin tomcat7-user apache2 apache2-utils unzip wget \
    && mkdir /opt/install

WORKDIR /opt/install
    
RUN wget https://github.com/DICE-UNC/irods-cloud-browser/releases/download/1.0.1-RELEASE/irods-cloud-backend-config.groovy \
    && wget https://github.com/DICE-UNC/irods-cloud-browser/releases/download/1.0.1-RELEASE/irods-cloud-backend.war \
    && wget https://github.com/DICE-UNC/irods-cloud-browser/releases/download/1.0.1-RELEASE/irods-cloud-frontend.zip
    
RUN rm -rf /var/lib/tomcat7/webapps/irods-cloud-backend \
    && mv irods-cloud-backend.war /var/lib/tomcat7/webapps/irods-cloud-backend.war \
    && echo '<Connector port="8009" protocol="AJP/1.3" />' >> /var/lib/tomcat7/conf/server.xml \
    && service tomcat7 start

RUN rm /var/www/html/index.html \
    && unzip irods-cloud-frontend.zip \
    && mv /opt/install/irods-cloud-frontend/* /var/www/html/ \
    && rm /opt/install/irods-cloud-frontend.zip \
    && rm /opt/install/irods-cloud-frontend \
    && a2enmod proxy \
    && a2enmod proxy_ajp \
    && a2enmod proxy_http \
    
ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN wget https://raw.githubusercontent.com/BiBBox/bibbox-scripts/master/addproxy.sh \
    && chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]