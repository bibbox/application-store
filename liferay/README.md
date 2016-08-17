![alt text](https://account.liferay.com/documents/14/8441540/Liferay-Logo-Website-Retina2.png/3aeff1e4-5d66-43de-8d54-ee7911ee8cb8?t=1398714210000 "Liferay logo")
# Docker System for Liferay BIBBOX Containers

The Liferay Docker system for BIBBOX is split into 3 Containers:
* [The Data Container](https://github.com/BiBBox/docker-tools/tree/master/liferay/image/liferay-data)
* [The Web Application Container](https://github.com/BiBBox/docker-tools/tree/master/liferay/image/liferay-application)
* [The Postgresql Container](https://hub.docker.com/_/postgres/)

This containers are composed into a liferay docker-compose file. For this bundl there is a start.sh script for starting a instance of the .yml file. To start a compose system for a BIBBOX installation you can use this script like:

```Bash
start.sh -I instanceName -s subdomain -p 9090 
```

You can also use this start script to modify it for your usecase.
