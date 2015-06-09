#!/bin/bash
BUILD_SUFFIX=$1
ODN_THEME_URL=git+https://github.com/OpenDataNode/ckanext-odn-theme.git@develop#egg=ckanext-odn-theme 

DIR=`pwd`
WORKDIR=/tmp/ckanext-odn-theme
mkdir $WORKDIR
pip install  -d $WORKDIR $ODN_THEME_URL
cd $WORKDIR
python setup.py sdist
cd $DIR
cp $WORKDIR/dist/* $DIR/ckan-commons/theme/ckanext-odn-theme.tar.gz
rm -rf $WORKDIR


# if BUILD_SUFFIX is not null
if [ -n "$BUILD_SUFFIX" ]; then
         # replace line in changelog e.g. "odn-ckan (2.2.1-odn0.10.1)" into "odn-ckan (2.2.1-odn0.10.1~rc5)" if rc5 has been set 
        find debian -name \*changelog -type f | xargs sed -i -r '1s/^([a-z,A-Z,\-]+) \(([0-9.]+).*\)/\1 (\2~'${BUILD_SUFFIX}')/'
fi

fakeroot debian/rules clean binary
