# Molgenis Installation
# 
# VERSION 0.0.1 
#

FROM tomcat:8.0-jre8

RUN apt-get update \
    && apt-get update -y \
    && wget -O molgenis-app-1.21.1.war http://search.maven.org/remotecontent?filepath=org/molgenis/molgenis-app/1.21.1/molgenis-app-1.21.1.war \
    && wget -O mysql-connector-java-5.1.28.jar http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.28/mysql-connector-java-5.1.28.jar \
    && rm -r $CATALINA_HOME/webapps/ROOT \
    && rm -r $CATALINA_HOME/webapps/docs \
    && rm -r $CATALINA_HOME/webapps/examples \
    && mv molgenis-app-1.21.1.war $CATALINA_HOME/webapps/molgenis-app-1.21.1.war \
    && mv mysql-connector-java-5.1.28.jar $CATALINA_HOME/lib/molgenis-app-1.21.1.war \
    && echo 'CATALINA_OPTS="-Xmx2g -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Dmolgenis.home=/opt/molgenis"' > $CATALINA_HOME/bin/setenv.sh \
    && mkdir /opt/molgenis
    
ADD scripts /scripts
WORKDIR /scripts
RUN chmod a+x *.sh

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
