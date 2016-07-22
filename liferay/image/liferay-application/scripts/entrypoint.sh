#!/bin/bash
echo "Starting Liferay Application Container!"

file="/opt/liferay/portal-setup-wizard.properties"
tomcat="tomcat-7.0.62"

#Config
if [[ ! -f "$file" ]]; then

ln /conf/portal-ext.properties /opt/liferay/portal-ext.properties
ln /conf/functions /ect/init.d/functions

sed -i "s/DATABASEPASSWORD/${POSTGRES_PASSWORD}/g" /conf/portal-setup-wizard.properties
ln /conf/portal-setup-wizard.properties /opt/liferay/portal-setup-wizard.properties

sed -i "s/TOMCAT_INSTANCE_VERSION_NUMBER/$tomcat/g" /conf/liferay
ln /conf/liferay /etc/init.d/liferay

chown -r liferay:liferay /opt/liferay

fi

#Startu Up
service liferay start
tail -f /opt/liferay/$tomcat/logs/catalina.out