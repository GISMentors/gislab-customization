#!/bin/sh
set -e

###########################
### Compilation dependecies
###########################
apt-get install --yes flex bison libproj-dev libtiff-dev mesa-common-dev libglu1-mesa-dev libfftw3-dev libblas-dev liblapack-dev \
	libcairo-dev proj-bin libgdal1-dev libwxbase2.8-dev git gettext subversion emacs23-nox g++ python-numpy gdal-bin make cmake \
	libqt4-dev libqca2-dev libqca2-plugin-ossl python-qt4-dev python-qt4 libqscintilla2-dev pyqt4-dev-tools libgsl0-dev libqwt5-qt4-dev \
	libspatialindex-dev autoconf saga

if [ ! -d $homedir/src ]; then
    mkdir $homedir/src
fi
if [ ! -d $homedir/src/grass_71 ] ; then
    
    svn co http://svn.osgeo.org/grass/grass/trunk $homedir/src/grass_71
fi
if [ ! -d $homedir/src/geos_35 ] ; then
    svn co https://svn.osgeo.org/geos/branches/3.5/ $homedir/src/geos_35
fi
if [ ! -d $homedir/src/gdal_20 ] ; then
    svn co https://svn.osgeo.org/gdal/branches/2.0/gdal/ $homedir/src/gdal_20
fi
if [ ! -d $homedir/src/qgis_214 ] ; then
    git clone https://github.com/qgis/QGIS.git $homedir/src/qgis_214
    (cd $homedir/src/qgis_214 && git branch release-2_14 origin/release-2_14 && git checkout release-2_14)
fi
if [ ! -d $homedir/src/proj_49 ] ; then
    git clone https://github.com/OSGeo/proj.4.git $homedir/src/proj_49
    (cd $homedir/src/proj_49 && git branch 4.9 origin/4.9 && git checkout 4.9)
fi
chown gislab:gislabusers $homedir/src -R

exit 0
