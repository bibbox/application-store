#!/bin/bash

#Update Config Files

service liferay start
tail -f /opt/liferay/tomcat-7.0.62/logs/catalina.out