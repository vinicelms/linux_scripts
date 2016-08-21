#!/bin/bash
#
# Script to download and install OTRS with all dependecies
# This script is designed to be used on Debian (8.5 x64)
# Created by: Vinicius Celms
# Date: 20/08/2016
# Version: 1.0
#
# Documentation to develop this script: https://otrs.github.io/doc/manual/admin/5.0/en/html/manual-installation-of-otrs.html
# 

# Link to download OTRS and static directory to OTRS project
OTRS_DL_LINK="http://ftp.otrs.org/pub/otrs/otrs-5.0.12.tar.gz"
STATIC_PROJECT_DIRECTORY=/opt/otrs

# Message to output process
MESSAGE=""
PrintMessage(){
    clear
    MESSAGE="$MESSAGE\n$1"
    echo -e $MESSAGE
}

# Name of file
OTRS_FILE_NAME=$(echo $OTRS_DL_LINK | cut -d/ -f$(expr $(echo $OTRS_DL_LINK | grep -o '/' | wc -l) + 1))
PROJECT_NAME_INFLATED=""

# Download file
DownloadFile(){
    wget -O $OTRS_FILE_NAME $OTRS_DL_LINK
}

# Inflate files and define name of project
InflateFiles(){
    PROJECT_NAME_INFLATED=$(tar -tf $OTRS_FILE_NAME | head -1 | cut -d/ -f1) 
    tar -zxf $OTRS_FILE_NAME
}

# Move files to static directory
MoveFiles(){
    mv $PROJECT_NAME_INFLATED $STATIC_PROJECT_DIRECTORY
}

# Install dependencies
InstallDependencies(){
# To verify all dependencies use 'perl /opt/otrs/bin/otrs.CheckModules.pl'
    apt-get install -y libarchive-zip-perl libcrypt-eksblowfish-perl libcrypt-ssleay-perl libdbi-perl \ 
libdbd-mysql-perl libdbd-odbc-perl libdbd-pg-perl libencode-hanextra-perl libjson-xs-perl \
libmail-imapclient-perl libapache2-mod-perl2 libnet-dns-perl libnet-ldap-perl libtemplate-perl \
libtext-csv-xs-perl libxml-libxslt-perl libyaml-libyaml-perl libdigest-md5-perl
}

# Create user OTRS
CreateUser(){
    useradd -d $STATIC_PROJECT_DIRECTORY -c 'OTRS user' otrs
    usermod -G www-data otrs
}

# Activate default config files
ActivateConfig(){
    cd $STATIC_PROJECT_DIRECTORY
    cp Kernel/Config.pm.dist Kernel/Config.pm
}

#DownloadFile
if [ $? -eq 0 ]
    then
        PrintMessage "Download file: Success"
    else
        PrintMessage "Download file: Error"
fi

#InflateFiles
if [ $? -eq 0 ]
    then
        PrintMessage "Inflate files: Success"
    else
        PrintMessage "Inflate files: Error"
fi

#MoveFiles
if [ $? -eq 0 ]
    then
        PrintMessage "Move files: Success"
    else
        PrintMessage "Move files: Error"
fi

InstallDependencies
if [ $? -eq 0 ]
    then
        PrintMessage "Install dependencies: Success"
    else
        PrintMessage "Install dependencies: Error"
fi

#CreateUser
if [ $? -eq 0 ]
    then
        PrintMessage "Create user: Success"
    else
        PrintMessage "Create user: Error"
fi

#ActivateConfig
if [ $? -eq 0 ]
    then
        PrintMessage "Activate config: Success"
    else
        PrintMessage "Activate config: Error"
fi
