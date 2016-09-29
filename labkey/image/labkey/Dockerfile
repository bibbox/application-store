


FROM tomcat:8.0-jre8

RUN apt-get update \
    && apt-get -y install wget
	
WORKDIR /usr/local	

RUN wget http://labkey.s3.amazonaws.com/downloads/general/r/16.2/LabKey16.2-45209.14-community-bin.tar.gz \
	&& tar xfz LabKey16.2-45209.14-community-bin.tar.gz \
	&& rm LabKey16.2-45209.14-community-bin.tar.gz \
	&& mkdir labkey \
	&& cp -r LabKey16.2-45209.14-community-bin/tomcat-lib/* tomcat/lib/ \
	&& cp -r LabKey16.2-45209.14-community-bin/labkeywebapp/ labkey/labkeywebapp \
	&& cp -r LabKey16.2-45209.14-community-bin/modules/ labkey/modules \
	&& cp -r LabKey16.2-45209.14-community-bin/pipeline-lib/ labkey/pipeline-lib

ADD scripts /scripts
WORKDIR /scripts
RUN chmod a+x *.sh 

WORKDIR /usr/local
RUN mkdir tomcat/conf/Catalina \
	&& mkdir tomcat/conf/Catalina/localhost \
	&& cp LabKey16.2-45209.14-community-bin/labkey.xml tomcat/conf/Catalina/localhost/ 


ENTRYPOINT [ "/scripts/entrypoint.sh" ]