#!/bin/bash
#
# Script to download and install MediaWiki with PostgreSQL
# Created by: Vinicius Celms
# Date: 30/03/2017
# Version: 1.0
# Needs Super User: YES
#

MESSAGE=""
PrintMessage(){
	clear
	MESSAGE="$MESSAGE\n$1"
	echo -e $MESSAGE
}


LINK_MEDIAWIKI_DOWNLOAD='https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.0.tar.gz'
MEDIAWIKI_NAME=$(echo $LINK_MEDIAWIKI_DOWNLOAD | cut -d/ -f$(expr $(echo $LINK_MEDIAWIKI_DOWNLOAD | grep -o '/' | wc -l ) + 1))

# Install requirements
apt-get install apache2 postgresql php5 php5-pgsql libapache2-mod-php5 php5-apcu imagemagick php5-intl
if [ $? -eq 0 ]
	then
		PrintMessage "Install requirements: Sucess"
	else
		PrintMessage "Install requirements: Error"

# Inflate files
tar -zxf $MEDIAWIKI_NAME

# Move files to