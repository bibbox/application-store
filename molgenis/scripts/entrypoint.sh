#!/bin/bash
file="/opt/molgenis/molgenis-server.properties"

if [[ ! -f "$file" ]]; then

cat << EOF > $file
admin.password=${MOLGENIS_ADMIN_PASSWORD}
admin.email=${MOLGENIS_ADMIN_email}
db_user=molgenis
db_password=molgenis
db_uri=jdbc\:mysql\://molgenisdb/molgenis
molgenis.version=31
EOF

chown tomcat:tomcat $file

fi

$CATALINA_HOME/bin/startup.sh
tail -f $CATALINA_HOME/logs/catalina.out
