#!/bin/bash
echo "Starting LabKey Application Container!"

file="/usr/local/labkey/setup.done"
appDocBase="/usr/local/labkey/labkeywebapp"


#Config
if [[ ! -f "$file" ]]; then

cat << EOF > $file
LabKey installed
EOF

sed -i "s:@@appDocBase@@:$appDocBase:g" /usr/local/tomcat/conf/Catalina/localhost/labkey.xml
sed -i "s:@@jdbcUser@@:${POSTGRES_USER}:g" /usr/local/tomcat/conf/Catalina/localhost/labkey.xml
sed -i "s:@@jdbcPassword@@:${POSTGRES_PASSWORD}:g" /usr/local/tomcat/conf/Catalina/localhost/labkey.xml

sed -i "s:@@smtpHost@@:${SMTP_HOST}:g" /usr/local/tomcat/conf/Catalina/localhost/labkey.xml
sed -i "s:@@smtpUser@@:${SMTP_USER}:g" /usr/local/tomcat/conf/Catalina/localhost/labkey.xml
sed -i "s:@@smtpPort@@:${SMTP_PORT}:g" /usr/local/tomcat/conf/Catalina/localhost/labkey.xml

sed -i "s-jdbc:postgresql://localhost/labkey-jdbc:postgresql://labkeydb:5432/test-g" /usr/local/tomcat/conf/Catalina/localhost/labkey.xml

fi

#Start Up
$CATALINA_HOME/bin/startup.sh
tail -f $CATALINA_HOME/logs/catalina.out
