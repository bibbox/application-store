#!/bin/bash
rm -rf /srv
mkdir -p /srv/conf
cp config/* /srv/conf
docker rm irods-db
docker rm irods-icat
docker rm irods-cloudbrowser-backend
docker rm irods-cloudbrowser
docker rm irods-appstack-data
