#!/bin/bash
rm -rf /srv
mkdir -p /srv/conf
cp config/* /srv/conf
docker rm $(docker ps -qa)
