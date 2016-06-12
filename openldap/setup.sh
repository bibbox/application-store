#!/bin/bash

# When not limiting the open file descritors limit, the memory consumption of
# slapd is absurdly high. See https://github.com/docker/docker/issues/8231
ulimit -n 8192

file="/tmp/chrootpw.ldif"

if [[ ! -f "$file" ]]; then
        echo >&2 "Starting Setup"

        if [[ -z "$SLAPD_PASSWORD" ]]; then
                echo -n >&2 "Error: Container not configured and SLAPD_PASSWORD not set. "
                echo >&2 "You forget to add -e SLAPD_PASSWORD=... ?"
                SLAPD_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
                echo >&2 "Password was set to: $SLAPD_PASSWORD"
        fi

adminHashPass="$(slappasswd -s '$SLAPD_PASSWORD')"
cat > /tmp/chrootpw.ldif <<EOF
# specify the password generated above for "olcRootPW" section

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $adminHashPass

EOF
ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/chrootpw.ldif

echo >&2 "Includes"
echo >&2 "--------------------------\n"

cat > /tmp/all-schemas.conf <<EOF
include /etc/ldap/schema/core.schema
include /etc/ldap/schema/cosine.schema
include /etc/ldap/schema/nis.schema
include /etc/ldap/schema/inetorgperson.schema
include /tmp/ldap-cas-4.1.x/ldap-schemas/rd-connect-common.schema
include /tmp/ldap-cas-4.1.x/ldap-schemas/basicRDproperties.schema
include /tmp/ldap-cas-4.1.x/ldap-schemas/cas-management.schema
include /tmp/ldap-cas-4.1.x/ldap-schemas/pwm.schema
EOF

echo >&2 "Generate LDIFs"
echo >&2 "--------------------------\n"
mkdir -p /tmp/ldap-ldifs/fixed
slaptest -f /tmp/all-schemas.conf -F /tmp/ldap-ldifs
for f in /tmp/ldap-ldifs/cn\=config/cn\=schema/*ldif ; do
sed -rf /tmp/ldap-cas-4.1.x/ldap-schemas/fix-ldifs.sed "$f" > /tmp/ldap-ldifs/fixed/"$(basename "$f")"
done
# It rejects duplicates
for f in /tmp/ldap-ldifs/fixed/*.ldif ; do
ldapadd -Y EXTERNAL -H ldapi:/// -f "$f"
done

if [[ -z "$SLAPD_DOMAIN_PASSWORD" ]]; then
  echo -n >&2 "Error: Container not configured and LAPD_DOMAIN_PASSWORD not set. "
  echo >&2 "You forget to add -e LAPD_DOMAIN_PASSWORD=... ?"
  LAPD_DOMAIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo >&2 "Password was set to: $LAPD_DOMAIN_PASSWORD"
fi

echo >&2 "Add Domain Password"
echo >&2 "--------------------------\n"
domainHashPass="$(slappasswd -s '$LAPD_DOMAIN_PASSWORD')"
domainDN='dc=bibbox,dc=org'
adminName='admin'
adminDN="cn=$adminName,$domainDN"
adminGroupDN="cn=admin,ou=groups,$domainDN"

cat > /tmp/chdomain.ldif <<EOF
# Disallow anonymous binds
dn: cn=config
changetype: modify
add: olcDisallows
olcDisallows: bind_anon

# Allow authenticated binds
dn: cn=config
changetype: modify
add: olcRequires
olcRequires: authc

dn: olcDatabase={-1}frontend,cn=config
changetype: modify
add: olcRequires
olcRequires: authc

# replace to your own domain name for "dc=***,dc=***" section
# specify the password generated above for "olcRootPW" section

dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
  read by dn.base="$adminDN" read by * none

# We declare an index on uid
dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: uid pres,eq

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: $domainDN

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: $adminDN

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $domainHashPass

# These rules grant write access to LDAP topology parts
# based on admin group
dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcAccess
olcAccess: to attrs=userPassword,shadowLastChange
  by dn="$adminDN" write
  by group.exact="$adminGroupDN" write
  by anonymous auth
  by self write
  by * none
olcAccess: to dn.children="ou=people,$domainDN"
  attrs=pwmLastPwdUpdate,pwmEventLog,pwmResponseSet,pwmOtpSecret,pwmGUID
  by dn="$adminDN" manage
  by group.exact="$adminGroupDN" manage
  by group.exact="cn=pwmAdmin,ou=groups,$domainDN" manage
  by self manage
  by * none
olcAccess: to dn.children="ou=people,$domainDN"
  by dn="$adminDN" write
  by group.exact="$adminGroupDN" write
  by * read
olcAccess: to dn.children="ou=groups,$domainDN"
  by dn="$adminDN" write
  by group.exact="$adminGroupDN" write
  by * read
olcAccess: to dn.base="" by * read
olcAccess: to * by dn="$adminDN" write by * read
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/chdomain.ldif

# Now, a re-index is issued, as we declared new indexes on uid
service slapd stop
slapindex -b "$domainDN"
service slapd start

echo >&2 "Add Root Password"
echo >&2 "--------------------------\n"
if [[ -z "$SLAPD_ROOT_PASSWORD" ]]; then
  echo -n >&2 "Error: Container not configured and LAPD_ROOT_PASSWORD not set. "
  echo >&2 "You forget to add -e LAPD_ROOT_PASSWORD=... ?"
  LAPD_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo >&2 "Password was set to: $LAPD_ROOT_PASSWORD"
fi

rootHashPass="$(slappasswd -s '$LAPD_ROOT_PASSWORD')"

cat > /tmp/basedomain.ldif <<EOF
# replace to your own domain name for "dc=***,dc=***" section

dn: $domainDN
objectClass: top
objectClass: dcObject
objectclass: organization
o: RD-Connect
dc: rd-connect
dn: $adminDN
objectClass: organizationalRole
cn: $adminName
description: BiBBoX LDAP domain manager

dn: ou=people,$domainDN
objectClass: organizationalUnit
ou: people
description: BiBBoX platform users

dn: ou=groups,$domainDN
objectClass: organizationalUnit
ou: groups
description: BiBBoX platform groups

dn: ou=admins,ou=people,$domainDN
objectClass: organizationalUnit
ou: admins
description: BiBBoX platform privileged users

dn: ou=services,$domainDN
objectClass: organizationalUnit
ou: services
description: BiBBoX platform allowed services

dn: cn=root,ou=admins,ou=people,$domainDN
objectClass: inetOrgPerson
objectClass: basicRDproperties
uid: root
disabledAccount: FALSE
userPassword: $rootHashPass
cn: root
sn: root
displayName: root
mail: robert.reihs@medunigraz.at
description: A user named root

dn: $adminGroupDN
objectClass: groupOfNames
cn: admin
member: cn=root,ou=admins,ou=people,$domainDN
owner: cn=root,ou=admins,ou=people,$domainDN
description: Users with administration privileges

dn: cn=pwmAdmin,ou=groups,$domainDN
objectClass: groupOfNames
cn: pwmAdmin
member: cn=root,ou=admins,ou=people,$domainDN
owner: cn=root,ou=admins,ou=people,$domainDN
description: Users with administration privileges on PWM
EOF
ldapadd -x -D "$adminDN" -W -f /tmp/basedomain.ldif

echo >&2 "memberOfModify"
echo >&2 "--------------------------\n"
cat > /tmp/memberOfModify.ldif <<EOF
dn: cn=root,ou=admins,ou=people,$domainDN
changetype: modify
add: memberOf
memberOf: $adminGroupDN
memberOf: cn=pwmAdmin,ou=groups,$domainDN
EOF
ldapmodify -x -D "$adminDN" -W -f /tmp/memberOfModify.ldif

echo >&2 "defaultservice"
echo >&2 "--------------------------\n"
cat > /tmp/defaultservice.ldif <<EOF
# The default service
dn: uid=10000001,ou=services,dc=bibbox,dc=org
objectClass: casRegisteredService
uid: 10000001
EOF
base64 /tmp/ldap-cas-4.1.x/etc/services/HTTPS-10000001.json | sed 's#^# #;1 s#^#description::#;' >> /tmp/defaultservice.ldif
ldapadd -x -D "$adminDN" -W -f /tmp/defaultservice.ldif

sed -i 's/#BASE/BASE/g' /etc/ldap/ldap.conf
sed -i 's/dc=example,dc=com/dc=bibbox,dc=org/g' /etc/ldap/ldap.conf

else
        echo >&2 "Setup alredy done"
fi