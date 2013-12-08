#!/bin/bash
host=192.168.56.111
username=vagrant
confDir="/etc/httpd/conf.d/";
wwwDir="/var/www/html/";

echo "enter Directory name";
read directoryName

echo "enter Database name";
read dbName

echo "enter Host name"
read hostName

if [ ! -z "$hostName" ]
then
	echo "Add the host to the local hosts file";
	echo ${host} ${hostName} www.${hostName} *.${hostName} >> /etc/hosts
fi

ssh -o StrictHostKeyChecking=no -l ${username} ${host} << EOF
sudo su -

if [  -a ${wwwDir}${directoryName} ]
then
	echo "Directory exists";
else
	echo "create directory...";
	mkdir ${wwwDir}${directoryName}
        chmod 755 ${wwwDir}${directoryName}
fi

if [ ! -z "$dbName" ]
then
	echo "create database ...";
	mysql -h127.0.0.1 -uroot -pYOURSECRETPASS -e "create database ${dbName};"
fi

if [[ ! -z "$hostName" ]] && [[ ! -z "$directoryName"  ]]
then
	echo "creating Vhost ....";
	echo "<VirtualHost *:80>
        DocumentRoot /var/www/html/$directoryName/
        ServerName $hostName
        ServerAlias *.$hostName www.$hostName
        <Directory /var/www/html/$directoryName/>
                Options +Indexes +FollowSymLinks +MultiViews +Includes
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
	CustomLog /var/log/httpd/$hostName-access.log combined
  	ErrorLog /var/log/httpd/$hostName-error.log
</VirtualHost>" > /etc/httpd/conf.d/$hostName.conf
	
	echo "restarting Apache...";
	/etc/init.d/httpd restart
else
	echo "one of them empty";
fi 

echo "all done....";

EOF
