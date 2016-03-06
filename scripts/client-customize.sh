#!/bin/sh -x
set -e

##########################
### Install gedit & geany
##########################
apt-get update
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

##########
### Nvidia
##########
is_unit=`grep GISLAB_UNIQUE_ID /etc/gislab_version | grep gislab-unit | wc -l`
if [ $is_unit -eq 1 ] ; then
    apt-add-repository --yes ppa:ubuntu-x-swat/x-updates
    apt-get update
    apt-get install --yes nvidia-319 nvidia-settings
fi

############
### QGIS 2.8
############
if [ ! -d /etc/apt/sources.list.d ] ; then
    mkdir /etc/apt/sources.list.d
fi
### apt-add-repository --yes ppa:landa-martin/gislab-testing (QGIS 2.8)
apt-add-repository --yes ppa:landa-martin/gislab-gismentors # (QGIS 2.14 + GDAL 2.0)
apt-get update
apt-get install --yes --force-yes libgdal20 gdal-bin python-gdal
#apt-get install --yes --force-yes qgis python-qgis qgis-plugin-grass

### tmp fix (https://github.com/imincik/gis-lab/issues/402)
apt-get install --yes --force-yes lightdm-gtk-greeter=1.1.5-0ubuntu1
pip install numpy==1.8

exit 0
