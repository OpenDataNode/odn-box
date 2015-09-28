This package provides debian packages for simplified installation of ODN.

For installation manual please see: https://github.com/OpenDataNode/open-data-node/blob/master/INSTALL.md

To add sysadmin user run:
~~~bash
. /usr/share/python/odn-ckan-shared/bin/activate 
paster --plugin=ckan   sysadmin  add  jmc -c   /etc/odn-simple/odn-ckan-ic/production.ini
~~~
To add normal user run:
~~~bash
. /usr/share/python/odn-ckan-shared/bin/activate 
 paster --plugin=ckan   user  add  kovac -c   /etc/odn-simple/odn-ckan-ic/production.ini
~~~


How to uninstall with dependency 
~~~bash
apt-get purge odn-simple
apt-get autoremove 
~~~


How to create .deb packages for odn-simple and odn-solr on Debian:
~~~bash
cd odn && fakeroot debian/rules clean binary
~~~
