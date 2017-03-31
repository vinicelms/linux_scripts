# OTRS - Download and Install

This script is designed for personal use on the ground to download and install OTRS.

Some variables may assist in handling this script if interest use.

> **OTRS:** https://www.otrs.com/

> This script was developed for use in Debian. It not tested in other systems. Debian 8.5 was used.

## Tools used in the script
- wget
- cut
- expr
- grep
- wc
- sed

## Variables

### Referenced variables to change
- **OTRS_DL_LINK** - _Link to download OTRS (Regardless of the version)_
- **STATIC_PROJECT_DIRECTORY** - _Directory to define where you want to keep the OTRS_

### Automatically generated variables
- **OTRS_FILE_NAME** - _Gets the file name according to the download link in the variable `OTRS_DL_LINK`_
- **PROJECT_NAME_INFLATED** - _Gets the directory name create in moment package was downloaded_

## After run script
Go to `installer page` and follow the procedures to configure OTRS.

**Installer page:** [URL]\otrs\installer.pl

### Example:
**Installer page example:** 127.0.0.1/otrs/installer.pl