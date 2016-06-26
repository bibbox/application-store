#!/bin/bash
file="/opt/molgenis/molgenis-server.properties"

if [[ ! -f "$file" ]]; then

cat << EOF > $file
admin.password=${MOLGENIS_ADMIN_PASSWORD}
admin.email=${MOLGENIS_ADMIN_email}
db_user=MYSQL_USER
db_password=${MYSQL_PASSWORD}
db_uri=jdbc\:mysql\://molgenisdb/MYSQL_DATABASE
molgenis.version=31
EOF

chown tomcat:tomcat $file

fi

$CATALINA_HOME/bin/startup.sh
tail -f $CATALINA_HOME/logs/catalina.out
