# Oracle JDK + Tomcat - Download and Install

This script is designed for personal use on the ground to download and install Oracle JDK (Java Development Kit) and Tomcat.

Some variables may assist in handling this script if interest use.

> **JDK:** _http://www.java.com/en/download/faq/develop.xml_
> **Tomcat:** _https://tomcat.apache.org/index.html_
> This script was developed for use in Debian. It not tested in other systems. Debian 8.4 was used.

## Tools used in the script
  - wget
  - cut
  - expr
  - grep
  - wc
  - sed

## Variables

### Referenced variables to change
  - **LINK_JDK_DOWNLOAD** - _Link to download JDK (Regardless of the version)_
  - **MD5_JDK_ORIGINAL** - _MD5 of JDK to compare after download_
  - **LINK_TOMCAT_DOWNLOAD** - _Link to download Tomcat (Regardless of the version)_
  - **MD5_TOMCAT_ORIGINAL** - _MD5 of Tomcat to compare after download_
  - **JDK_SYSTEM_DIRECTORY** - _Directory to define where you want to keep the JDK_
  - **TOMCAT_SYSTEM_DIRECTORY** - _Directory to define where you want to keep the Tomcat_

### Automatically generated variables
  - **JDK_FILE_NAME** - _Gets the file name according to the download link in the variable `LINK_JDK_DOWNLOAD`_
  - **TOMCAT_FILE_NAME** - _Gets the file name according to the download link in the variable `LINK_TOMCAT_DOWNLOAD`_
  - **JDK_PROJECT_NAME** - _Sets the project name according to the file name in the variable `JDK_FILE_NAME`_
  - **TOMCAT_PROJECT_NAME** - _Sets the project name according to the file name in the variable `TOMCAT_FILE_NAME`_
  - **JDK_DIRECTORY_NAME** - _Sets the project directory when extracted in_ `ExtractJDK` _function_
  - **TOMCAT_DIRECTORY_NAME** - _Sets the project directory when extracted in_ `ExtractTomcat` _function_
  - **TOMCAT_SERVICE_CONTROL** - _Sets the name of the script file to manage the Tomcat service using the variable `TOMCAT_PROJECT_NAME`_
