This package provides debian packages for simplified installation of ODN.

Content of solr directory is as-is copy of solr configuration directory with schema.xml from CKAN.

TODO:
- replace hostname in configuration files
- package UnifiedViews
- establish package repository

Usage: apt-get install odn-simple

Till the package repository will be established use this

~~~bash
dpkg -i odn-solr_4.10.2-1_all.deb odn-ckan-shared_2.2.1-1_amd64.deb  odn-simple_0.9-2_all.deb
#... some dependency errors
apt-get install -f -y
~~~


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
apt-get purge odn-simple odn-ckan-shared odn-solr 
apt-get autoremove 
~~~


How to create .deb packages for odn-simple and odn-solr on Debian:
~~~bash
cd odn && fakeroot debian/rules clean binary
~~~
