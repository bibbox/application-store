![alt text](http://bibbox.org/image/layout_set_logo?img_id=99523&t=1466419185262 "Logo BiBBoX")
# Docker Tools for OpenSpecimen

Linux environment to build OpenSpecimen from the source code.
Contains all the prerequisites installed to be able to build the OpenSpecimen from [source code] (https://github.com/krishagni/openspecimen).
The openspecimen.war file built will be placed in openspecimen/build/libs/. More information on how to build from source code is 
available [here] (https://openspecimen.atlassian.net/wiki/pages/viewpage.action?pageId=1115955).
 
The whole image is available at [docker hub] (https://hub.docker.com/r/suyesh/gradle/). The image also contains the openspecimen.war file.
Simply copy the war file and deploy it in the tomcat/webapps/ directory.

Docker Pull Command:
docker pull suyesh/gradle