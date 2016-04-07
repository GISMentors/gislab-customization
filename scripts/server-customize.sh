#!/bin/sh
set -e

apt-get install --yes git emacs23-nox gdal-bin

homedir=/mnt/home/gislab
gitdir="dataset"
if [ ! -d ${homedir}/${gitdir} ] ; then
    cd $homedir
    git clone https://github.com/GISMentors/${gitdir}.git
else
    cd ${homedir}/${gitdir}
    git pull
fi

#######################
### Change SSH port ###
#######################
#is_unit=`grep GISLAB_UNIQUE_ID /etc/gislab_version | grep gislab-unit | wc -l`
#if [ $is_unit -eq 1 ] ; then
#    sed -i 's/Port 22/Port 12345/g' /etc/ssh/sshd_config
#    service ssh restart
#fi

###########################
### Compilation dependecies
###########################
apt-get install --yes flex bison libproj-dev libtiff-dev mesa-common-dev libglu1-mesa-dev libfftw3-dev libblas-dev liblapack-dev \
	libcairo-dev proj-bin libgdal1-dev libwxbase2.8-dev git gettext subversion emacs23-nox g++ python-numpy gdal-bin make cmake \
	libqt4-dev libqca2-dev libqca2-plugin-ossl python-qt4-dev python-qt4 libqscintilla2-dev pyqt4-dev-tools libgsl0-dev libqwt5-qt4-dev \
	libspatialindex-dev autoconf

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
    (cd $homedir/src/qgis_214 && git branch 4.9 origin/4.9 && git checkout 4.9)
fi
chown gislab:gislabusers $homedir/src -R

schema_priv() {
    psql -U postgres $db -c "GRANT USAGE on SCHEMA $1 to $2"
    psql -U postgres $db -c "GRANT SELECT ON ALL TABLES IN SCHEMA $1 TO $2"
}

revoke_priv() {
    psql -U postgres $db -c "revoke create on schema public from $1"
    psql -U postgres $db -c "revoke create on database $db from $1"
    psql -U postgres $db -c "REVOKE ALL ON schema public FROM public"
}

#################
### GISMentors DB
#################
gismentors_db() {
    db=gismentors

    cd /mnt/repository
    if [ ! -f $db.dump ] ; then
	wget http://training.gismentors.eu/geodata/postgis/$db.dump
    fi
    if [ `psql -U postgres -l | grep -c $db` -eq 1 ] ; then
	dropdb -U postgres $db
    fi
    createdb -U postgres $db
    pg_restore /mnt/repository/$db.dump | psql -U postgres $db
    ${homedir}/${gitdir}/postgis/epsg-5514.sh
    
    schema_priv public gislabusers
    schema_priv dibavod gislabusers
    schema_priv osm gislabusers
    schema_priv rastry gislabusers
    schema_priv ruian gislabusers
    schema_priv ruian_praha gislabusers
    schema_priv csu_sldb gislabusers
    schema_priv slhp gislabusers
    schema_priv ochrana_uzemi gislabusers
    
    revoke_priv gislabusers
}

gismentors_db

#############################
### GISMentors GRASS Location
#############################
gismentors_grass() {
    cd /mnt/repository
    if [ ! -d grassdata ] ; then
	mkdir grassdata && cd grassdata
	wget http://training.gismentors.eu/geodata/grass/gismentors.zip
	unzip gismentors.zip
	wget http://training.gismentors.eu/geodata/grass/gismentors-landsat.zip
	unzip gismentors-landsat.zip  
    fi

    cd /opt/gislab/system/accounts/skel/grassdata/
    rm -rf gismentors
    mkdir gismentors
    cd gismentors
    ln -s /mnt/repository/grassdata/gismentors/PERMANENT .
    ln -s /mnt/repository/grassdata/gismentors/dibavod .
    ln -s /mnt/repository/grassdata/gismentors/landsat .
    ln -s /mnt/repository/grassdata/gismentors/ochrana_uzemi .
    ln -s /mnt/repository/grassdata/gismentors/osm .
    ln -s /mnt/repository/grassdata/gismentors/ruian .
    ln -s /mnt/repository/grassdata/gismentors/ruian_praha .
    cp -r /mnt/repository/grassdata/gismentors/user1 gislab
    sed -i 's/user1/gislab/g' gislab/SEARCH_PATH
    
    cd /opt/gislab/system/accounts/skel/.grass7
    sh -c 'echo "export TMPDIR=/mnt/booster" > bashrc'
    sh -c 'echo "export GRASS_VECTOR_TEMPORARY=move" >> bashrc'
    sh -c 'echo "export GRASS_VECTOR_TMPDIR_MAPSET=0" >> bashrc'
    sed -i 's/world/gismentors/g' rc
}

gismentors_grass

###################
### GISMentors data
###################
gismentors_data() {
    datadir=/mnt/repository/gismentors
    rm -rf $datadir && mkdir $datadir
    
    ${homedir}/${gitdir}/postgis/export_shp.sh
    mv /tmp/gismentors_shp $datadir/shp

    cd $datadir
    if [ ! -f dmt.tif ] ; then
        wget http://training.gismentors.eu/geodata/eu-dem/dmt.zip
        unzip dmt.zip
        rm dmt.zip
    fi

    if [ ! -d txt ] ; then
        (mkdir txt && cd txt;
        wget https://github.com/GISMentors/qgis-zacatecnik/files/39270/export.txt;
        wget https://github.com/GISMentors/qgis-zacatecnik/files/39271/xy_data.txt)
    fi

    if [ ! -f WP_20160403.tar.bz2 ] ; then
        wget https://github.com/GISMentors/dataset/raw/master/foto/WP_20160403.tar.bz2
        tar xjf WP_20160403.tar.bz2
        rm WP_20160403.tar.bz2
    fi
}

gismentors_data

exit 0
