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

UPLOAD_FILESIZE_PARAM=20M
MEMORY_LIMIT_PARAM=128M

# Install requirements
apt-get install -y apache2 postgresql php5 php5-pgsql libapache2-mod-php5 php5-apcu imagemagick php5-intl
if [ $? -eq 0 ]
	then
		PrintMessage "Install requirements: Success"
	else
		PrintMessage "Install requirements: Error"
fi

# Download MediaWiki
wget -O $MEDIAWIKI_NAME $LINK_MEDIAWIKI_DOWNLOAD
if [ $? -eq 0 ]
	then
		PrintMessage "Download MediaWiki: Success"
	else
		PrintMessage "Download MediaWiki: Error"
fi

# Inflate files
tar -zxf $MEDIAWIKI_NAME
if [ $? -eq 0 ]
	then
		PrintMessage "Inflate files: Success"
	else
		PrintMessage "Inflate files: Error"
fi

# Move files MediaWiki directory ($MEDIAWIKI_STATIC_DIRECTORY)
mv $(echo $MEDIAWIKI_NAME | cut -d. -f-$(expr $($MEDIAWIKI_NAME | grep -o '\.' | wc -l) - 1)) $MEDIAWIKI_STATIC_DIRECTORY
if [ $? -eq 0 ]
	then
		PrintMessage "Move files to $MEDIAWIKI_STATIC_DIRECTORY: Success"
	else
		PrintMessage "Move files to $MEDIAWIKI_STATIC_DIRECTORY: Error"
fi

# Change configuration on 'php.ini'

# Get upload_max_filesize line number
UPLOADFILESIZE_LINE=$(awk '/upload_max_filesize/{ print NR; exit}' /etc/php5/apache2/php.ini)

# Get upload_max_filesize value
UPLOADFILESIZE_INFO=$(sed $UPLOADFILESIZE_LINE"q;d" /etc/php5/apache2/php.ini)
UPLOADFILESIZE_INFO=$(echo ${UPLOADFILESIZE_INFO: -3})

# Set value to upload_max_filesize
UPLOADFILESIZE_INFO=$UPLOADFILESIZE_LINE"s/"$UPLOADFILESIZE_INFO"/${UPLOAD_FILESIZE_PARAM}/"
sed -i "$(echo $UPLOADFILESIZE_INFO)" /etc/php5/apache2/php.ini
if [ $? -eq 0 ]
	then
		PrintMessage "Change parameter 'upload_max_filesize' to ${UPLOAD_FILESIZE_PARAM}: Success"
	else
		PrintMessage "Change parameter 'upload_max_filesize' to ${UPLOAD_FILESIZE_PARAM}: Error"
fi

# Get memory_limit line number
MEMORYLIMIT_LINE=$(awk '/memory_limit/{ print NR; exit}' /etc/php5/apache2/php.ini)

# Get memory_limit value
MEMORYLIMIT_INFO=$(sed $MEMORYLIMIT_LINE"q;d" /etc/php5/apache2/php.ini)
MEMORYLIMIT_INFO=$(echo ${MEMORYLIMIT_INFO: -3})

# Set value to memory_limit
MEMORYLIMIT_INFO=$MEMORYLIMIT_LINE"s/"$MEMORYLIMIT_INFO"/${MEMORY_LIMIT_PARAM}/"
sed -i "$(echo $MEMORYLIMIT_INFO)" /etc/php5/apache2/php.ini
if [ $? -eq 0 ]
	then
		PrintMessage "Change parameter 'memory_limit' to ${MEMORY_LIMIT_PARAM}: Success"
	else
		PrintMessage "Change parameter 'memory_limit' to ${MEMORY_LIMIT_PARAM}: Error"
fi

# Create symbolic link from MediaWiki directory ($MEDIAWIKI_STATIC_DIRECTORY)
cd /var/www/html
ln -s $MEDIAWIKI_STATIC_DIRECTORY $(echo $MEDIAWIKI_STATIC_DIRECTORY | cut -d/ -f$(expr $(echo $MEDIAWIKI_STATIC_DIRECTORY | grep -o '/' | wc -l ) + 1))
if [ $? -eq 0 ]
	then
		PrintMessage "Create symbolic link from MediaWiki: Success"
	else
		PrintMessage "Create symbolic link from MediaWiki: Error"
fi

# Delete downloaded file
rm -rf $MEDIAWIKI_NAME
if [ $? -eq 0 ]
	then
		PrintMessage "Delete downloaded file: Success"
	else
		PrintMessage "Delete downloaded file: Error"
fi