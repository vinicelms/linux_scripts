# MediaWiki + PostgreSQL - Download and Install

This script is designed for personal use on the ground to download and install MediaWiki with PostgreSQL.

Some variables may assist in handling this script if interest use.

> MediaWiki: https://www.mediawiki.org/wiki/MediaWiki

> PostgreSQL: https://www.postgresql.org/

>  This script was developed for use in Debian. It not tested in other systems. Debian 8.7.1 was used.

## Tools used in the script
- wget
- sed
- awk
- cut
- expr
- grep
- wc

## Variables

### Referenced variables to change
- **LINK_MEDIAWIKI_DOWNLOAD** - _Link to download MediaWiki (Regardless of the version)_
- **MEDIAWIKI_STATIC_DIRECTORY** - _Directory to define where you want to keep the MediaWiki_
- **UPLOAD_FILESIZE_PARAM** - _Parameter to define filesize upload in PHP_
- **MEMORY_LIMIT_PARAM** - _Parameter to define memory limite of PHP consume_

### Automatically generated variables
- **MEDIAWIKI_NAME** - _Gets the file name according to the download link in the variable `LINK_MEDIAWIKI_DOWNLOAD`_