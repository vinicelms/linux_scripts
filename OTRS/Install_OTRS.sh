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
libtext-csv-xs-perl libxml-libxslt-perl libyaml-libyaml-perl libdigest-md5-perl apache2 mysql-server
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

# Check if all needed modules are installed
CheckModules(){
    perl -cw perl -cw $STATIC_PROJECT_DIRECTORY/bin/cgi-bin/index.pl
    if [ $? -eq 0 ]
    then
        PrintMessage "Index module: Success"
    else
        PrintMessage "Index module: Error"
    fi

    perl -cw $STATIC_PROJECT_DIRECTORY/bin/cgi-bin/customer.pl
    if [ $? -eq 0 ]
    then
        PrintMessage "Customer module: Success"
    else
        PrintMessage "Customer module: Error"
    fi

    perl -cw $STATIC_PROJECT_DIRECTORY/bin/otrs.Console.pl
    if [ $? -eq 0 ]
    then
        PrintMessage "Console module: Success"
    else
        PrintMessage "Console module: Error"
    fi
}

# Configuring the Apache web server
ConfigureApacheWebServer(){
    a2enmod perl
    if [ $? -eq 0 ]
        then
            PrintMessage "Apache Module (Perl): Success"
        else
            PrintMessage "Apache Module (Perl): Error"
    fi

    a2enmod version
    if [ $? -eq 0 ]
        then
            PrintMessage "Apache Module (Deflate): Success"
        else
            PrintMessage "Apache Module (Deflate): Error"
    fi

    a2enmod filter
    if [ $? -eq 0 ]
        then
            PrintMessage "Apache Module (Filter): Success"
        else
            PrintMessage "Apache Module (Filter): Error"
    fi

    a2enmod headers
    if [ $? -eq 0 ]
        then
            PrintMessage "Apache Module (Headers): Success"
        else
            PrintMessage "Apache Module (Headers): Error"
    fi
}

# Adjust file permissions to OTRS user
FilePermission(){
    $STATIC_PROJECT_DIRECTORY/bin/otrs.SetPermissions.pl --web-group=www-data
}

# Configure MySQL config file
ConfigureMysqlFile(){
    STATIC_MAXALLOWED=20M
    STATI

    FINE_TUNING_LINE=$(awk '/Fine Tuning/{ print NR; exit }' /etc/mysql/my.cnf)
    FINE_TUNING_LINE=$(expr $FINE_TUNING_LINE + 2)
    FINE_TUNING_INFO=$FINE_TUNING_LINE"iinnodb_log_file_size = 256M"
    sed -i "$(echo $FINE_TUNING_INFO)" /etc/mysql/my.cnf

    MAXALLOWED_LINE=$(awk '/max_allowed_packet/{ print NR; exit }' /etc/mysql/my.cnf)
    MAXALLOWED_INFO=$(sed $MAXALLOWED_LINE"q;d" /etc/mysql/my.cnf)
    MAXALLOWED_INFO=$(echo ${MAXALLOWED_INFO: -3})
    MAXALLOWED_INFO=$MAXALLOWED_LINE"s/"$MAXALLOWED_INFO"/20M/"
    sed -i "$(echo $MAXALLOWED_INFO)" /etc/mysql/my.cnf

    QUERYCACHE_LINE=$(awk '/query_cache_size/{ print NR; exit }' /etc/mysql/my.cnf)
    QUERYCACHE_INFO=$(sed $QUERYCACHE_LINE"q;d" /etc/mysql/my.cnf)
    QUERYCACHE_INFO=$(echo ${QUERYCACHE_INFO: -3})
    QUERYCACHE_INFO=$QUERYCACHE_LINE"s/"$QUERYCACHE_INFO"/32M/"
    sed -i "$(echo $QUERYCACHE_INFO)" /etc/mysql/my.cnf
    sed $QUERYCACHE_LINE"q;d" /etc/mysql/my.cnf

    # Verifies that the configuration is correct
    INNODB_CONFIRM=$(awk '/innodb_log_file_size = 256M/{ print NR; exit }' /etc/mysql/my.cnf)
    if [ $INNODB_CONFIRM -eq $FINE_TUNING_LINE ]
        then
            PrintMessage "MySQL config (INNODB): Success"
        else
            PrintMessage "MySQL config (INNODB): Error"
    fi

    MAXALLOWED_CONFIRM=$(sed $MAXALLOWED_LINE"q;d" /etc/mysql/my.cnf)
    MAXALLOWED_CONFIRM=$(echo ${MAXALLOWED_CONFIRM: -3})
    if [ $MAXALLOWED_CONFIRM == "20M" ]
        then
            PrintMessage "MySQL config (MAX_ALLOWED_PACKET): Success"
        else
            PrintMessage "MySQL config (MAX_ALLOWED_PACKET): Error"
    fi

    QUERYCACHE_CONFIRM=$(sed $QUERYCACHE_LINE"q;d" /etc/mysql/my.cnf)
    QUERYCACHE_CONFIRM=$(echo ${QUERYCACHE_CONFIRM: -3})
    if [ $QUERYCACHE_CONFIRM == "32M" ]
        then
            PrintMessage "MySQL config (QUERY_CACHE_SIZE): Success"
        else
            PrintMessage "MySQL config (QUERY_CACHE_SIZE): Error"
    fi
}

# Start Daemon
StartDaemon(){
    runuser -l otrs -c "/opt/otrs/bin/otrs.Daemon.pl start"
}

# Set Daemon in CronJobs
SetDaemonCron(){
    cd /opt/otrs/var/cron
    for foo in *.dist; do cp $foo `basename $foo .dist`; done
}

# Schedule Daemon on CronJobs
ScheduleDaemonCron(){
    runuser -l otrs -c "/opt/otrs/bin/Cron.sh start"
}

DownloadFile
if [ $? -eq 0 ]
    then
        PrintMessage "Download file: Success"
    else
        PrintMessage "Download file: Error"
fi

InstallDependencies
if [ $? -eq 0 ]
    then
        PrintMessage "Install dependencies: Success"
    else
        PrintMessage "Install dependencies: Error"
fi

CreateUser
if [ $? -eq 0 ]
    then
        PrintMessage "Create user: Success"
    else
        PrintMessage "Create user: Error"
fi

ActivateConfig
if [ $? -eq 0 ]
    then
        PrintMessage "Activate config: Success"
    else
        PrintMessage "Activate config: Error"
fi

CheckModules

ConfigureApacheWebServer

FilePermission
if [ $? -eq 0 ]
    then
        PrintMessage "File permission: Success"
    else
        PrintMessage "File permission: Error"
fi

ConfigureMysqlFile

StartDaemon
if [ $? -eq 0 ]
    then
        PrintMessage "Start Daemon: Success"
    else
        PrintMessage "Start Daemon: Error"
fi

SetDaemonCron
if [ $? -eq 0 ]
        then
            PrintMessage "Set Daemon Cron: Success"
        else
            PrintMessage "Set Daemon Cron: Error"
fi

ScheduleDaemonCron
if [ $? -eq 0 ]
    then
        PrintMessage "Schedule Daemon Cron: Success"
    else
        PrintMessage "Schedule Daemon Cron: Error"
fi