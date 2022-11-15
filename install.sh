#!/bin/bash

apt-get -y update
apt-get -y upgrade
wget https://packages.openxpki.org/v3/debian/Release.key -O - | apt-key add -
gpg --print-md sha256 Release.key
echo "deb http://packages.openxpki.org/v3/debian/ buster release" > /etc/apt/sources.list.d/openxpki.list
apt-get -y update
apt-get -y install default-mysql-server libdbd-mysql-perl
apt-get -y install apache2 libapache2-mod-fcgid
apt-get -y install libopenxpki-perl openxpki-cgi-session-driver openxpki-i18n
mysql -e "CREATE DATABASE openxpki CHARSET utf8;CREATE USER 'openxpki'@'localhost' IDENTIFIED BY 'openxpki';GRANT ALL ON openxpki.* TO 'openxpki'@'localhost';flush privileges;"
zcat /usr/share/doc/libopenxpki-perl/examples/schema-mariadb.sql.gz | mysql -u root --password --database  openxpki
mkdir -p /etc/openxpki/local/keys
bash /usr/share/doc/libopenxpki-perl/examples/sampleconfig.sh
openxpkictl start
