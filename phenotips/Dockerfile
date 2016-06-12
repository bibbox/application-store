# phenotips installation
# 
# VERSION 0.0.1 
#

FROM tomcat:8.0.32-jre8

MAINTAINER Robert Reihs <robert.reihs@gmail.com>

RUN apt-get update \
    && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
    && sed -i 's/max_allowed_packet      = 16M/max_allowed_packet      = 64M/g' /etc/mysql/my.cnf

COPY setupDB.sql /opt/setupDB.sql
COPY startup.sh /opt/startup.sh
 
RUN service mysql start \
    && chmod +x /opt/startup.sh \
    && sed -i 's/redirectPort="8443"/redirectPort="8443" URIEncoding="UTF-8"/g' /usr/local/tomcat/conf/server.xml \
    && mysql -h localhost -u root < /opt/setupDB.sql \
    && wget https://nexus.phenotips.org/nexus/content/repositories/releases/org/phenotips/phenotips-war/1.2.3/phenotips-war-1.2.3.war \
    && wget https://nexus.phenotips.org/nexus/content/repositories/releases/org/phenotips/solr-configuration/1.2.3/solr-configuration-1.2.3.jar \
    && unzip phenotips-war-1.2.3.war -d /opt/ROOT \
    && rm -R /usr/local/tomcat/webapps/ROOT \
    && mv /opt/ROOT /usr/local/tomcat/webapps/ \
    && mkdir -p /var/lib/phenotips \
    && unzip solr-configuration-1.2.3.jar -d /opt/solr \
    && mv /opt/solr /var/lib/phenotips/ \
    && sed -i 's/# xwiki.db=xwiki/xwiki.db=phenotips/g' /usr/local/tomcat/webapps/ROOT/WEB-INF/xwiki.cfg \
    && sed -i 's/# xwiki.store.attachment.hint=hibernate/xwiki.store.attachment.hint=file/g' /usr/local/tomcat/webapps/ROOT/WEB-INF/xwiki.cfg \
    && sed -i 's/# xwiki.store.attachment.versioning.hint=hibernate/xwiki.store.attachment.versioning.hint=file/g' /usr/local/tomcat/webapps/ROOT/WEB-INF/xwiki.cfg \
    && sed -i 's/# xwiki.store.attachment.recyclebin.hint=hibernate/xwiki.store.attachment.recyclebin.hint=file/g' /usr/local/tomcat/webapps/ROOT/WEB-INF/xwiki.cfg
    

COPY hibernate.cfg.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/hibernate.cfg.xml

CMD ["/opt/startup.sh"]
    

# setup mysql

#https://phenotips.org/AdminGuide/Installation+on+Tomcat+and+MySQL
#GNU/Linux as the operating system
#JDK 1.7+, either Open JDK or Oracle JDK
#Apache Tomcat 7+ as the servlet container
#MySQL with InnoDB as the database
#Apache HTTPD with mod_proxy_ajp as a reverse proxy
#Postfix for sending emails

#docker run -t -i bibbox/phenotips:1.2.3 /bin/bash

#https://ariejan.net/2007/12/12/how-to-install-mysql-on-ubuntudebian/
# Set MySql password after the installation (no Password is default)
# mysqladmin -u root -h localhost password 'mypassword'


#https://nexus.phenotips.org/nexus/content/repositories/releases/org/phenotips/phenotips-war/1.2.3/phenotips-war-1.2.3.war