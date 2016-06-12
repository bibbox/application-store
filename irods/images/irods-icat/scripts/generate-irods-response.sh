#!/bin/bash

# generate-irods-response.sh
# Original Author: Michael J. Stealey <michael.j.stealey@gmail.com>
# Modified by: Peter van Heusden <pvh@sanbi.ac.za>

################################
### CONFIGURE iRODS SETTINGS ###
################################

IRODS_CONFIG_FILE=$1

# Refresh environment variables derived from updated config file
mkdir /files
sed -e "s/:[^:\/\/]/=/g;s/$//g;s/ *=/=/g" ${IRODS_CONFIG_FILE} > /files/irods-config.sh
while read line; do export $line; done < <(cat /files/irods-config.sh)

RESPFILE=$2

echo ${SERVICE_ACCT_USERNAME} > $RESPFILE       # service account user ID
echo ${SERVICE_ACCT_GROUP} >> $RESPFILE         # service account group ID
echo ${IRODS_ZONE} >> $RESPFILE                 # initial zone name
echo ${IRODS_PORT} >> $RESPFILE                 # service port #
echo ${RANGE_BEGIN} >> $RESPFILE                # transport starting port #
echo ${RANGE_END} >> $RESPFILE                  # transport ending port #
echo ${VAULT_DIRECTORY} >> $RESPFILE            # vault path
echo ${ZONE_KEY} >> $RESPFILE                   # zone key
echo ${NEGOTIATION_KEY} >> $RESPFILE            # negotiation key
echo ${CONTROL_PLANE_PORT} >> $RESPFILE         # control plane port
echo ${CONTROL_PLANE_KEY} >> $RESPFILE          # control plane key
echo ${SCHEMA_VALIDATION_BASE_URI} >> $RESPFILE # schema validation base URI
echo ${ADMINISTRATOR_USERNAME} >> $RESPFILE     # iRODS admin account
echo ${ADMINISTRATOR_PASSWORD} >> $RESPFILE     # iRODS admin password
echo "yes" >> $RESPFILE                         # confirm iRODS settings
echo ${HOSTNAME_OR_IP} >> $RESPFILE             # database hostname
echo ${DATABASE_PORT} >> $RESPFILE              # database port
echo ${DATABASE_NAME} >> $RESPFILE              # database DB name
echo ${DATABASE_USER} >> $RESPFILE              # database admin username
echo ${DATABASE_PASSWORD} >> $RESPFILE          # database admin password
echo "yes" >> $RESPFILE                         # confirm database settings

exit;
