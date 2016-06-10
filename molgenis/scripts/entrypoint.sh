#!/bin/bash
file="/opt/molgenis/molgenis-server.properties"

if [[ ! -f "$file" ]]; then

cat << EOF > $file
admin.password=${MOLGENIS_ADMIN_PASSWORD}
admin.email=${MOLGENIS_ADMIN_email}
db_user=${MYSQL_USER}
db_password=${MYSQL_PASSWORD}
db_uri=jdbc\:mysql\://${MOLGENIS-MYSQL_PORT_5432_TCP_ADDR}/${MYSQL_DATABASE}
EOF



fi

$CATALINA_HOME/bin/startup.sh
tail -f $CATALINA_HOME/logs/catalina.out
