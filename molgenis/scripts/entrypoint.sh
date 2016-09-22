#!/bin/bash
file="/opt/molgenis/molgenis-server.properties"

if [[ ! -f "$file" ]]; then

cat << EOF > $file
admin.password=${MOLGENIS_ADMIN_PASSWORD}
admin.email=${MOLGENIS_ADMIN_email}
db_user=${MYSQL_USER}
db_password=${MYSQL_PASSWORD}
db_uri=jdbc\:mysql\://molgenisdb/${MYSQL_DATABASE}
molgenis.version=31
security.cas.enabled=${MOLGENIS_USE_CAS:=false}
EOF

if [[ "${MOLGENIS_USE_CAS}" -eq "true" ]]; then
cat << EOF >> "${file}"
security.cas.login.url=${MOLGENIS_CAS_BASEURL}/p3
security.cas.logout.url=${MOLGENIS_CAS_BASEURL}/logout
security.cas.server.ticket.validator.url=${MOLGENIS_CAS_BASEURL}/p3
security.cas.callback.base.url=${MOLGENIS_CAS_CALLBACK_URL}
EOF
fi

fi

$CATALINA_HOME/bin/startup.sh
tail -f $CATALINA_HOME/logs/catalina.out
