#!/bin/bash
service mysql start
/usr/local/tomcat/bin/startup.sh
tail -f /usr/local/tomcat/logs/catalina.out