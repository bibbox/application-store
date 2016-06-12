### irods-icat in Docker

There are two parts of this repository. The `compose` directory contains a `docker-compose` file for starting an iRODS catalogue
server (in a simplistic 1 catalogue / 0 resource servers configuration) with the software in Docker containers and the 
persistent data mounted as volumes.

The second part, in the `images` directory, contains two image definitions, for *pvanheus/appstack-data*, a data-only container
for linking volumes to containers and *pvanheus/irods-icat*, the container that contains the ICAT catalogue daemon. The 
third container used, for the PostgreSQL database server, is simply the standard *postgres:9.3* container.

The idea for how to run the iRODS catalogue server within Docker was derived in part from `hs-docker-irods`, part of the 
HydroShare project.
