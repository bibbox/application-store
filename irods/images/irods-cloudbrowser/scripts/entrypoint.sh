#!/bin/bash
echo "Starting iRODS Cloud Browser 0.0.2!"

file="/opt/scripts/installed"

##Setup
if [[ ! -f "$file" ]]; then
sed -i 's/location.hostname+":8080/${CLOUD_BACKEND_SUBDOMAIN}.${CLOUD_BACKEND_URL}/g' /usr/local/apache2/htdocs/app/components/globals.js <-- ${..} funktioniert nicht
sed -i 's/ServerAdmin you@example.com/ServerAdmin robert.reihs@gmail.com/g' /usr/local/apache2/conf/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName ${CLOUD_BROWSER_SUBDOMAIN}.${CLOUD_BROWSER_URL}/g' /usr/local/apache2/conf/httpd.conf <-- ${..} funktioniert nicht

cat << EOF > $file
iRODS Cloud Browser 0.0.2 installed
EOF

fi 

httpd-foreground