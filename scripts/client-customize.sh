#!/bin/sh
set -e

##########################
### Use UbuntuGIS
##########################
apt-add-repository --yes ppa:ubuntugis/ubuntugis-unstable
apt-add-repository --yes ppa:libreoffice/ppa # dh-python
apt-get update

##########################
### Install gedit & geany
##########################
apt-get install --no-install-recommends --yes gedit geany sqlitebrowser
# sed -i 's/leafpad/gedit/g' /etc/xdg/xdg-xubuntu/xfce4/panel/default.xml 

###############
### Python libs
###############
apt-get install --yes python-pip g++ python-dev libgdal-dev python-numpy 
pip install Fiona
pip install rasterio
pip install shapely
pip install OWSLib

##########################
### PostGIS (common files)
##########################
apt-get install --yes postgis

##########################
### SAGA & OTB
##########################
apt-get install --yes saga otb-bin otb-bin-qt python-otb

##########
### Nvidia
##########
is_unit=`grep GISLAB_UNIQUE_ID /etc/gislab_version | grep gislab-unit | wc -l`
if [ $is_unit -eq 1 ] ; then
    apt-add-repository --yes ppa:ubuntu-x-swat/x-updates
    apt-get update
    apt-get install --yes nvidia-settings-319 nvidia-settings
fi

###############
### GIS.lab PPA
###############
if [ ! -d /etc/apt/sources.list.d ] ; then
    mkdir /etc/apt/sources.list.d
fi
#apt-add-repository --yes ppa:landa-martin/gislab-testing # (QGIS 2.8)
#apt-get update
### apt-add-repository --yes ppa:landa-martin/gislab-gismentors # (QGIS 2.14 + GDAL 2.0)

############
### QGIS 2.8
############
### apt-get install --yes --force-yes libgdal20 gdal-bin python-gdal libgeos-3.5.0
#apt-get install --yes --force-yes qgis python-qgis qgis-plugin-grass

############
### QGIS 2.14
############
apt-get install --yes --force-yes libqca2 python-qt4-sql pyqt4-dev-tools qt4-designer libimage-exiftool-perl

#######################################################
### Fix (https://github.com/imincik/gis-lab/issues/402)
#######################################################
apt-get install --yes --force-yes lightdm-gtk-greeter=1.1.5-0ubuntu1
pip install numpy==1.8

apt-get --yes --force-yes autoremove

exit 0
