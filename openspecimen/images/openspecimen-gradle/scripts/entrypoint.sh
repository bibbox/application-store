#!/bin/bash
echo "Starting Gradle Container for OpenSpecimen!"

wget -O openspec.zip "$releaseURL"
mv openspecimen* openspecimen
cd /opt/openspecimen/
npm install -g grunt
gradle buildNeeded


#1. npm install -g grunt-cli
#2. npm init
#   fill all details and it will create a package.json file.
#3. npm install grunt (for grunt dependencies.)

#Edit : Updated solution for new versions:

# npm install grunt --save-dev