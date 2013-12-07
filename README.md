Bash script to generate a vhost on remote host.

Introduction:
====
    - creates project directory in /var/www/html/
    - creates a vhost
    - creates database
    - add entry to local /etc/hosts file
    - restarts apache


Installtion:
====
    - download
    - chmod 777 createvhosts.sh
    - run ./createvhost.sh

    *you can put it also under /usr/local/bin*

Requirements:
============

remote host must be a CentOS installation

ubuntu users have to change some paths f.e /etc/init.d/http to /etc/init.d/apache2


