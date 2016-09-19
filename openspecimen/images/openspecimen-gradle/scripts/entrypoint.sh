#!/bin/bash
echo "Starting Gradle Container for OpenSpecimen!"

wget -O openspec.zip "$RELEASEURL"
unzip openspec.zip
mv openspecimen* openspecimen
cd /opt/openspecimen/

sed -i "s/<app_container_home>/${TOMCATPATH}/g" /opt/openspecimen/build.properties
sed -i "s/<app_data_dir>/???/g" /opt/openspecimen/build.properties
sed -i "s/app_log_conf =/app_log_conf =???/g" /opt/openspecimen/build.properties
#datasource_jndi = java:/comp/env/jdbc/openspecimen
#deployment_type = fresh
sed -i "s/database_host = localhost/database_host = openspecimen-db-${INSTANCE}/g" /opt/openspecimen/build.properties
sed -i "s/database_name = osdb/database_name = ${MYSQL_DATABASE}/g" /opt/openspecimen/build.properties
sed -i "s/database_username = root/database_username = ${MYSQL_USER}/g" /opt/openspecimen/build.properties
sed -i "s/database_password = root/database_password = ${MYSQL_PASSWORD}/g" /opt/openspecimen/build.properties
#show_sql = false
#plugin_dir = <path-to-directory-containing-plugin-jars>

npm install -g grunt
gradle buildNeeded


#1. npm install -g grunt-cli
#2. npm init
#   fill all details and it will create a package.json file.
#3. npm install grunt (for grunt dependencies.)

#Edit : Updated solution for new versions:

#rm  npm install grunt --save-dev