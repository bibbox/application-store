#!/bin/sh

CONFIG_FILE=/conf/irods-config.yaml
if [ ! -f $CONFIG_FILE ] ; then
  cp -r /config-files/`basename $CONFIG_FILE` /conf
fi

tail -f /dev/null
