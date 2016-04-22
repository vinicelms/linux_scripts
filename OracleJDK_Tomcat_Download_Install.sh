#!/bin/bash
#
# Script to download and install Oracle JDK and Tomcat
# Created by: Vinicius Celms
# Date: 22/04/2016
# Version: 1.0
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

DownloadJDK(){
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $(echo $LINK_JDK_DOWNLOAD)
}

DownloadTomcat(){
    wget --no-check-certificate --no-cookies $(echo $LINK_TOMCAT_DOWNLOAD)
}

VerifyMD5JDK(){
    MD5_JDK_GENERATED=$(md5sum $JDK_FILE_NAME | cut -d' ' -f1)
    
    if [ $MD5_JDK_ORIGINAL == $MD5_JDK_GENERATED ]
    then
        return "Sucess"
    else
        return "ERROR"
    fi
}

VerifyMD5Tomcat(){
    MD5_TOMCAT_GENERATED=$(md5sum $TOMCAT_FILE_NAME | cut -d' ' -f1)

    if [ $MD5_TOMCAT_ORIGINAL == $MD5_TOMCAT_GENERATED ]
    then
        return "Sucess"
    else
        return "ERROR"
    fi   
}

ExtractJDK(){
    tar -zxf $JDK_FILE_NAME
}

ExtractTomcat(){
    tar -zxf $TOMCAT_FILE_NAME
}