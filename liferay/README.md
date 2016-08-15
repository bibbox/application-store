# Docker System for Liferay BIBBOX Containers

The Liferay Docker system for BIBBOX is split into 3 Containers:
* The Data Container
* The Web Application Container
* The Postgresql Container

This containers are composed into a liferay docker-compose file. For this bundl there is a start.sh script for starting a instance of the yml file. To start a compose for a BIBBOX installation you can use this script like:

```Bash
start.sh -I instanceName -s subdomain -p 9090 
```

You can also use this start script to modify it for your usecase.
