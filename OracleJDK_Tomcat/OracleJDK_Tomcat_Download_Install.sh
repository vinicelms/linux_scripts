#!/bin/bash
#
# Script to download and install Oracle JDK and Tomcat
# Created by: Vinicius Celms
# Date: 22/04/2016
# Version: 1.0
# Needs Super User: YES
#

# JDK - Link and MD5 hash to verify integrity
LINK_JDK_DOWNLOAD='http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz'
MD5_JDK_ORIGINAL='3f3d7d0cd70bfe0feab382ed4b0e45c0'

# Tomcat - Link and MD5 hash to verify integrity
LINK_TOMCAT_DOWNLOAD='http://ftp.unicamp.br/pub/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
MD5_TOMCAT_ORIGINAL='b1a57b6883ef098121035992a61ed0c6'

# Get name file that it will be downloaded
JDK_FILE_NAME=$(echo $LINK_JDK_DOWNLOAD | cut -d/ -f$(expr $(echo $LINK_JDK_DOWNLOAD | grep -o '/' | wc -l ) + 1))
TOMCAT_FILE_NAME=$(echo $LINK_TOMCAT_DOWNLOAD | cut -d/ -f$(expr $(echo $LINK_TOMCAT_DOWNLOAD | grep -o '/' | wc -l) + 1))

# Set name project
JDK_PROJECT_NAME=$(echo $JDK_FILE_NAME | cut -d- -f1,2 | sed 's/\-//g')
TOMCAT_PROJECT_NAME=$(echo $TOMCAT_FILE_NAME | cut -d- -f2,3 | sed 's/\-//g' | cut -d. -f1,2,3 | sed 's/\./_/g')

# Declaring directory name extracted
JDK_DIRECTORY_NAME=""
TOMCAT_DIRECTORY_NAME=""

# Set System Directory
JDK_SYSTEM_DIRECTORY="/usr/lib/jvm"
TOMCAT_SYSTEM_DIRECTORY="/opt"

# Set file name to control service Tomcat
TOMCAT_SERVICE_CONTROL="$(echo $TOMCAT_PROJECT_NAME | cut -d_ -f1)"

DownloadJDK(){
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     -O $JDK_FILE_NAME $LINK_JDK_DOWNLOAD
}

DownloadTomcat(){
    wget --no-check-certificate --no-cookies -O $TOMCAT_FILE_NAME $LINK_TOMCAT_DOWNLOAD
}

VerifyMD5JDK(){
    MD5_JDK_GENERATED=$(md5sum $JDK_FILE_NAME | cut -d' ' -f1)
    
    if [ $MD5_JDK_ORIGINAL == $MD5_JDK_GENERATED ]
    then
        return 0
    else
        return 1
    fi
}

VerifyMD5Tomcat(){
    MD5_TOMCAT_GENERATED=$(md5sum $TOMCAT_FILE_NAME | cut -d' ' -f1)

    if [ $MD5_TOMCAT_ORIGINAL == $MD5_TOMCAT_GENERATED ]
    then
        return 0
    else
        return 1
    fi   
}

ExtractJDK(){
    JDK_DIRECTORY_NAME=$(tar -zxvf $JDK_FILE_NAME | head -1 | cut -d/ -f1)
    tar -zxf $JDK_FILE_NAME
}

ExtractTomcat(){
    TOMCAT_DIRECTORY_NAME=$(tar -zxvf $TOMCAT_FILE_NAME | head -1 | cut -d/ -f1)
    tar -zxf $TOMCAT_FILE_NAME
}

ChangeDirectoryNameJDK(){
    mv $JDK_DIRECTORY_NAME $JDK_PROJECT_NAME
}

ChangeDirectoryNameTomcat(){
    mv $TOMCAT_DIRECTORY_NAME $TOMCAT_PROJECT_NAME
}

MoveJDKSystemDirectory(){
    mkdir -p $JDK_SYSTEM_DIRECTORY/$JDK_PROJECT_NAME
    mv $JDK_PROJECT_NAME $JDK_SYSTEM_DIRECTORY
}

MoveTomcatSystemDirectory(){
    mkdir -p $TOMCAT_SYSTEM_DIRECTORY/$TOMCAT_PROJECT_NAME
    mv $TOMCAT_PROJECT_NAME $TOMCAT_SYSTEM_DIRECTORY
}

WriteJDKDefinitions(){ # Needs Super User
    JDK_WRITE="\n# Declaration Oracle JDK\n\
JAVA_HOME=$JDK_SYSTEM_DIRECTORY/$JDK_PROJECT_NAME\n\
PATH=$(echo $)JAVA_HOME/bin:$(echo $)PATH export PATH JAVA_HOME\n\
CLASSPATH=$(echo $)JAVA_HOME/lib/tools.jar\n\
CLASSPATH=.:$(echo $)CLASSPATH\n\
export PATH JAVA_HOME CLASSPATH"

    echo -e $JDK_WRITE >> /etc/profile
}

ChangeVariableValueTomcatFile(){
    sed -i "s/TOMCAT=TOMCAT_SYSTEM_DIRECTORY/TOMCAT=\\$TOMCAT_SYSTEM_DIRECTORY\/$TOMCAT_PROJECT_NAME/g" tomcat
    sed -i "s/JAVA_HOME=JDK_SYSTEM_DIRECTORY/JAVA_HOME=$(echo $JDK_SYSTEM_DIRECTORY/$JDK_PROJECT_NAME | sed 's/\//\\\//g')/g" tomcat
}

RenameTomcatFile(){
    mv tomcat $(echo $TOMCAT_PROJECT_NAME | cut -d_ -f1)
}

InstallServiceTomcat(){
    mv $(echo $TOMCAT_PROJECT_NAME | cut -d_ -f1) /etc/init.d/
    update-rc.d tomcat8 defaults &>/dev/null
}

StartApplications(){
    source /etc/profile
    service $TOMCAT_SERVICE_CONTROL start
}

RemoveFilesDownloaded(){
    rm -rf $JDK_FILE_NAME $TOMCAT_FILE_NAME
}

DownloadJDK && clear
DownloadTomcat && clear

VerifyMD5JDK
if [ $? -eq 0 ]
    then
        echo "Download JDK: Success"
    else
        echo "Download JDK: ERROR"
        exit 1
fi

VerifyMD5Tomcat
if [ $? -eq 0 ]
    then
        echo "Download Tomcat: Success"
    else
        echo "Download Tomcat: ERROR"
        exit 1
fi

ExtractJDK
if [ $? -eq 0 ]
    then
        echo "Extract JDK: Success"
    else
        echo "Extract JDK: ERROR"
        exit 1
fi

ExtractTomcat
if [ $? -eq 0 ]
    then
        echo "Extract Tomcat: Success"
    else
        echo "Extract Tomcat: ERROR"
        exit 1
fi

ChangeDirectoryNameJDK
if [ $? -eq 0 ]
    then
        echo "Change Directory Name JDK: Success"
    else
        echo "Change Directory Name JDK: ERROR"
        exit 1
fi

ChangeDirectoryNameTomcat
if [ $? -eq 0 ]
    then
        echo "Change Directory Name Tomcat: Success"
    else
        echo "Change Directory Name Tomcat: ERROR"
        exit 1
fi

MoveJDKSystemDirectory # Needs Super User
if [ $? -eq 0 ]
    then
        echo "Move JDK to $JDK_SYSTEM_DIRECTORY: Success"
    else
        echo "Move JDK to $JDK_SYSTEM_DIRECTORY: ERROR"
        exit 1
fi

MoveTomcatSystemDirectory # Needs Super User
if [ $? -eq 0 ]
    then
        echo "Move Tomcat to $TOMCAT_SYSTEM_DIRECTORY: Success"
    else
        echo "Move Tomcat to $TOMCAT_SYSTEM_DIRECTORY: ERROR"
        exit 1
fi

WriteJDKDefinitions
if [ $? -eq 0 ]
    then
        echo "Declaration JDK in /etc/profile: Success"
    else
        echo "Declaration JDK in /etc/profile: ERROR"
        exit 1
fi

ChangeVariableValueTomcatFile
if [ $? -eq 0 ]
    then
        echo "Change Tomcat variable in file to control service: Success"
    else
        echo "Change Tomcat variable in file to control service: ERROR"
        exit 1
fi

RenameTomcatFile
if [ $? -eq 0 ]
    then
        echo "Rename Tomcat file to control service: Success"
    else
        echo "Rename Tomcat file to control service: ERROR"
        exit 1
fi

InstallServiceTomcat
if [ $? -eq 0 ]
    then
        echo "Service Tomcat: Success"
    else
        echo "Service Tomcat: ERROR"
        exit 1
fi

StartApplications
if [ $? -eq 0 ]
    then
        echo "Starting Applications: Success"
    else
        echo "Starting Applications: ERROR"
        exit 1
fi

RemoveFilesDownloaded
if [ $? -eq 0 ]
    then
        echo "Remove files Downloaded: Success"
    else
        echo "Remove files Downloaded: ERROR"
        exit 1
fi

exit 0