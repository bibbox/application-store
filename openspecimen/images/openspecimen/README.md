![alt text](http://bibbox.org/image/layout_set_logo?img_id=99523&t=1466419185262 "Logo BiBBoX")
# Docker Tools for OpenSpecimen


The Dockerfile installs JDK 8 and Tomcat 7.0.70.
Copies tomcat-users.xml and context.xml to /opt/tomcat/conf/

Specifies MySQL MySQL root user (username="root" password="openspecimen")

Copies openspecimen.war /opt/tomcat/webapps/

Also copies mysql-connector-java to /opt/tomcat/lib/ 
