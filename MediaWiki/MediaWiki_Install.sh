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
MEDIAWIKI_STATIC_DIRECTORY=/var/lib/mediawiki

# Install requirements
apt-get install apache2 postgresql php5 php5-pgsql libapache2-mod-php5 php5-apcu imagemagick php5-intl
if [ $? -eq 0 ]
	then
		PrintMessage "Install requirements: Success"
	else
		PrintMessage "Install requirements: Error"
fi

# Inflate files
tar -zxf $MEDIAWIKI_NAME
if [ $? -eq 0 ]
	then
		PrintMessage "Inflate files: Success"
	else
		PrintMessage "Inflate files: Error"
fi

# Move files to /var/lib/mediawiki ($MEDIAWIKI_STATIC_DIRECTORY)
mv $MEDIAWIKI_NAME $MEDIAWIKI_STATIC_DIRECTORY
if [ $? -eq 0 ]
	then
		PrintMessage "Move files to $MEDIAWIKI_STATIC_DIRECTORY: Success"
	else
		PrintMessage "Move files to $MEDIAWIKI_STATIC_DIRECTORY: Error"
fi

# Change configuration on 'php.ini'
