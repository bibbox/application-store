#!/bin/bash
echo "Starting Gradle Container for OpenSpecimen!"

wget -O openspec.zip "$RELEASEURL"
unzip openspec.zip
mv openspecimen* openspecimen
cd /opt/openspecimen/

sed -i "s#<app_container_home>#/opt/tomcat#g" /opt/openspecimen/build.properties
sed -i "s#<app_data_dir>#/opt/openspecimen/os-data#g" /opt/openspecimen/build.properties
sed -i "s/database_host = localhost/database_host = openspecimen-db-${INSTANCE}/g" /opt/openspecimen/build.properties
sed -i "s/database_name = osdb/database_name = ${MYSQL_DATABASE}/g" /opt/openspecimen/build.properties
sed -i "s/database_username = root/database_username = ${MYSQL_USER}/g" /opt/openspecimen/build.properties
sed -i "s/database_password = root/database_password = ${MYSQL_PASSWORD}/g" /opt/openspecimen/build.properties
sed -i "s#<path-to-directory-containing-plugin-jars>#/opt/openspecimen/os-plugins#g" /opt/openspecimen/build.properties

npm install -g grunt
gradle buildNeeded


#1. npm install -g grunt-cli
#2. npm init
#   fill all details and it will create a package.json file.
#3. npm install grunt (for grunt dependencies.)

#Edit : Updated solution for new versions:

#rm  npm install grunt --save-dev