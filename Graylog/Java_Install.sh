#!/bin/bash
#
# Script to download and install Oracle JDK and Tomcat
# Created by: Vinicius Celms
# Date: 03/04/2017
# Version: 1.0
# Needs Super User: YES
#

# Message to output process
MESSAGE=""
PrintMessage(){
    clear
    MESSAGE="$MESSAGE\n$1"
    echo -e $MESSAGE
}

# JDK - Link and MD5 hash to verify integrity
LINK_JDK_DOWNLOAD='http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz'
MD5_JDK_ORIGINAL='91972fb4e753f1b6674c2b952d974320'

# Get name file that it will be downloaded
JDK_FILE_NAME=$(echo $LINK_JDK_DOWNLOAD | cut -d/ -f$(expr $(echo $LINK_JDK_DOWNLOAD | grep -o '/' | wc -l ) + 1))

# Declaring directory name extracted
JDK_DIRECTORY_NAME=""

# Set System Directory
JDK_SYSTEM_DIRECTORY="/usr/lib/jvm"

# Download JDK
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
-O $JDK_FILE_NAME $LINK_JDK_DOWNLOAD

if [ $? -eq 0 ]
	then
		PrintMessage "Download JDK: Success"
	else
		PrintMessage "Download JDK: Error"
fi

# Check download JDK integrity
MD5_JDK_GENERATED=$(md5sum $JDK_FILE_NAME | cut -d' ' -f1)
if [ $MD5_JDK_ORIGINAL == $MD5_JDK_GENERATED ]
	then
		PrintMessage "MD5 JDK: Success"
	else
		PrintMessage "MD5 JDK: Error"
fi

# Inflate JDK files
JDK_DIRECTORY_NAME=$(tar -zxvf $JDK_FILE_NAME | head -1 | cut -d/ -f1)
tar -zxf $JDK_FILE_NAME
if [ $? -eq 0 ]
	then
		PrintMessage "Inflate JDK files: Success"
	else
		PrintMessage "Inflate JDK files: Error"
fi

 # Move JDK to System Directory
 mv $JDK_DIRECTORY_NAME $JDK_SYSTEM_DIRECTORY
 if [ $? -eq 0 ]
 	then
 		PrintMessage "Move JDK files to ${JDK_SYSTEM_DIRECTORY}: Success"
 	else
 		PrintMessage "Move JDK files to ${JDK_SYSTEM_DIRECTORY}: Error"
 fi

 # Write JDK info in /etc/profile to Path Variable Environment
 JDK_WRITE="\n# Declaration Oracle JDK\n\
JAVA_HOME=$JDK_SYSTEM_DIRECTORY/$JDK_PROJECT_NAME\n\
PATH=$(echo $)JAVA_HOME/bin:$(echo $)PATH export PATH JAVA_HOME\n\
CLASSPATH=$(echo $)JAVA_HOME/lib/tools.jar\n\
CLASSPATH=.:$(echo $)CLASSPATH\n\
export PATH JAVA_HOME CLASSPATH"

echo -e $JDK_WRITE >> /etc/profile
if [ $? -eq 0 ]
	then
		PrintMessage "Write JDK info in /etc/profile: Success"
	else
		PrintMessage "Write JDK info in /etc/profile: Error"
fi

# Reaload file /etc/profile
source /etc/profile
if [ $? -eq 0 ]
	then
		PrintMessage "Reload file /etc/profile: Success"
	else
		PrintMessage "Reload file /etc/profile: Error"
fi

# Remove downloaded files
rm -rf $JDK_FILE_NAME
if [ $? -eq 0 ]
	then
		PrintMessage "Remove JDK file: Success"
	else
		PrintMessage "Remove JDK file: Error"
fi