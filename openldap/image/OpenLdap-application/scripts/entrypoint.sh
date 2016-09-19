#!/bin/bash
service slapd start

source /setup.sh

service slapd restart

tail -f /dev/null