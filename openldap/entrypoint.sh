#!/bin/bash
echo "Starting OpenLdap Container!"

file="/opt/liferay/setup.done"
if [[ ! -f "$file" ]]; then
    
cat << EOF > $file
OpenLdap 0.0.1 installed
EOF

sed -i "s/#BASE   dc=example,dc=com/BASE   dc=example,dc=com/g" /etc/ldap/ldap.conf
sed -i "s§#URI    ldap://ldap.example.com ldap://ldap-master.example.com:666§$tomcat§g" /etc/ldap/ldap.conf

fi

#Startu Up



File

#BASE   dc=example,dc=com
#URI    ldap://ldap.example.com ldap://ldap-master.example.com:666
