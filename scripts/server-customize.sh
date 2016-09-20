#!/bin/sh
set -e

HOMEDIR=/mnt/home/gislab

###########################
### Compilation dependecies
###########################
apt-get install --yes flex bison libproj-dev libtiff-dev mesa-common-dev libglu1-mesa-dev libfftw3-dev libblas-dev liblapack-dev \
	libcairo-dev proj-bin libgdal1-dev libwxbase2.8-dev git gettext subversion emacs23-nox g++ python-numpy gdal-bin make cmake \
	libqt4-dev libqca2-dev libqca2-plugin-ossl python-qt4-dev python-qt4 libqscintilla2-dev pyqt4-dev-tools libgsl0-dev libqwt5-qt4-dev \
	libspatialindex-dev autoconf saga libfcgi-dev

if [ ! -d $HOMEDIR/src ]; then
    mkdir $HOMEDIR/src
fi
if [ ! -d $HOMEDIR/src/grass_72 ] ; then
    svn co http://svn.osgeo.org/grass/grass/branches/releasebranch_7_2 $HOMEDIR/src/grass_72
fi
if [ ! -d $HOMEDIR/src/geos_35 ] ; then
    svn co https://svn.osgeo.org/geos/branches/3.5/ $HOMEDIR/src/geos_35
fi
if [ ! -d $HOMEDIR/src/gdal_21 ] ; then
    svn co https://svn.osgeo.org/gdal/branches/2.1/gdal/ $HOMEDIR/src/gdal_21
fi
if [ ! -d $HOMEDIR/src/qgis_214 ] ; then
    git clone https://github.com/qgis/QGIS.git $HOMEDIR/src/qgis_214
    (cd $HOMEDIR/src/qgis_214 && git branch release-2_14 origin/release-2_14 && git checkout release-2_14)
fi
if [ ! -d $HOMEDIR/src/proj_49 ] ; then
    git clone https://github.com/OSGeo/proj.4.git $HOMEDIR/src/proj_49
    (cd $HOMEDIR/src/proj_49 && git branch 4.9 origin/4.9 && git checkout 4.9)
fi
chown gislab:gislabusers $HOMEDIR/src -R

exit 0
