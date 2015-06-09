#!/bin/bash

DIR=`pwd`
WORKDIR=$DIR/ckanext-odn-theme
mkdir $WORKDIR
pip install  -d $WORKDIR git+https://github.com/OpenDataNode/ckanext-odn-theme.git@ODN_v1.0.2#egg=ckanext-odn-theme || true
cd $WORKDIR
python setup.py sdist
cd $DIR
mkdir -p $DIR/ckan-commons/theme/
cp $WORKDIR/dist/* $DIR/ckan-commons/theme/ckanext-odn-theme.tar.gz

