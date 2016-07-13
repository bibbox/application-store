#!/bin/bash
service postgresql start

file="/tmp/setupdone"

if [[ ! -f "$file" ]]; then

su postgres << 'EOF'
psql -c "CREATE ROLE liferay LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;"
psql -c "CREATE DATABASE lportal;"
psql -c "ALTER USER liferay PASSWORD 'bM456OEw';"
psql -c "GRANT ALL ON DATABASE lportal TO liferay;"
pg_restore -c -d lportal /opt/db_backup.sql
EOF

sed -i 's/jdbc.default.password=bM74JuwMbFpulHSBk9CChMMO77T2!SqtB$aqhiz/jdbc.default.password=bM456OEw/g' /opt/liferay/portal-setup-wizard.properties

cat > /tmp/setupdone <<EOF
Setup Done
EOF

fi

/opt/liferay/tomcat-7.0.42/bin/startup.sh
tail -f /opt/liferay/tomcat-7.0.42/logs/catalina.out