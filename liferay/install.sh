#!/bin/bash
tool="liferay"
instance="instance"
folderprefix="/opt/bibbox/"
folder="${folderprefix}liferay-instance"
url="demo.bibbox.org"
ip="127.0.0.1"
subdomain="notset"

addproxy="/opt/bibbox/bibbox-scripts/addproxy.sh"

PROGNAME=$(basename $0)

echo "Starting $tool Containers"

usage()
{
    echo "Usage:    start [OPTIONS]"
    echo "          start [ --help | -v | --version ]"
    echo ""
    echo "Creates Instance of the compose docker file"
    echo ""
    echo "OPTIONS:"
    echo "      -I, --instance                  Set Instance Name"
    echo "      -s, --subdomain                 Set Subdomain for Proxy"
    echo "      -p, --port                      Set Port for Proxy"
    echo "      -i, --ip                        Set IP for Proxy if different from standard"
    echo "      -u, --url                       Set URL for Proxy if different from standard"
    echo ""
    echo "Example:"
    echo "       sudo ./start.sh -i instance1"
}

version()
{
  echo "Version: 1.1"
  echo "BIBBOX Version: 1.0"
  echo "Build: 2016-07-14"
  echo "Tool: $tool"
}

clean_up() {

	# Perform program exit housekeeping
	# Optionally accepts an exit status
	
	exit $1
}

error_exit()
{
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	clean_up 1
}

checkParametersUpdateVariables() 
{
    folder="$folderprefix$tool-$instance"
    if [[ "$instance" = "instance" ]]; then
        echo "No seperate instance name set for $tool!"
    fi
    
    if [[  "$subdomain" = "notset" ]]; then
        error_exit "$LINENO: Subdomain not set! Aborting."
    fi
}

checkCreatConfig()
{
    if [[ ! -d "$folder" ]]; then
        echo "Create folders and config for $tool"
        mkdir -p "${folder}"
        mkdir -p "${folder}/liferay/data"
        mkdir -p "${folder}/postgresql/data/pgdata"
        cp docker-compose.yml "${folder}/docker-compose.yml"
        cp config "${folder}"
        sed -i "s#§§FOLDER#$folder#g" "${folder}/docker-compose.yml"
        createPassword
        echo "Password: $password"
        sed -i "s#§§SET_PGSETUP_POSTGRES_PASSWORD#$password#g" "${folder}/docker-compose.yml"
        sed -i "s#§§INSTANCE#$instance#g" "${folder}/docker-compose.yml"
        sed -i "s#§§PORT#$port#g" "${folder}/docker-compose.yml"
        sed -i "s#liferay-db#liferay-db-$instance#g" "${folder}/config/portal-setup-wizard.properties"
    fi
}

createPassword()
{
    password=$(openssl rand -base64 30)
}

addProxy()
{
    if [[ -f "$addproxy" ]]; then
        runcommand="$addproxy -t $tool-$instance -p $port -u $url -s $subdomain -i $ip"
    else
        echo "Proxy Script dose not exist in $addproxy"
        
    fi
}

runDockerCompose()
{
    cd ${folder}
    docker-compose up -d
}

removeContainer()
{
    cd ${folder}
    docker-compose stop
    cd /opt
    rm -r "${folder}"
    docker rm "liferay-application-$instance"
    docker rm "liferay-data-$instance"
    docker rm "liferay-db-$instance"
    docker rmi bibbox/liferay-application
    docker rmi bibbox/liferay-data
}

run()
{
    checkParametersUpdateVariables
    checkCreatConfig
    addProxy
    runDockerCompose
    clean_up
}

while [ "$1" != "" ]; do
    case $1 in
        -I | --instance )       shift
                                instance=$1
                                ;;
        -p | --port )           shift
                                port=$1
                                ;;
        -u | --url )            shift
                                url=$1
                                ;;
        -s | --subdomain )      shift
                                subdomain=$1
                                ;;
        -i | --ip )             shift
                                ip=$1
                                ;;
        -h | --help )           usage
                                clean_up
                                ;;
        -v | --version | version )  version
                                clean_up
                                ;;
        * )                     usage
                                error_exit "Parameters not matching"
    esac
    shift
done

run





