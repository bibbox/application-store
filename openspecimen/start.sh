#!/bin/sh
echo "Starting OpenSpecimen Containers"

folder="/opt/openspecimen"

if [[ ! -d "$folder" ]]; then
    mkdir -p /opt/openspecimen/var/lib/mysql
    mkdir -p /opt/openspecimen/etc/mysql/conf.d
    
    cp config/openspecimen.cnf /opt/openspecimen/etc/mysql/conf.d/openspecimen.cnf
fi