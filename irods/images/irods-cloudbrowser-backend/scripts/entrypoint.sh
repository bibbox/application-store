#!/bin/bash
echo "Starting iRODS Cloud Browser Backend 0.0.2!"

file="/etc/irods-cloud-backend-config.groovy"

##Setup
if [[ ! -f "$file" ]]; then
sed -i "s/beconf.login.preset.host='localhost'/beconf.login.preset.host='irods-icat'" /irods-cloud-backend-config.groovy
mv /irods-cloud-backend-config.groovy /etc/irods-cloud-backend-config.groovy
fi 

$CATALINA_HOME/bin/startup.sh
tail -f $CATALINA_HOME/logs/catalina.out