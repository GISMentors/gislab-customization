#!/bin/sh
set -e

#######################
### Change SSH port ###
#######################
#is_unit=`grep GISLAB_UNIQUE_ID /etc/gislab_version | grep gislab-unit | wc -l`
#if [ $is_unit -eq 1 ] ; then
#    sed -i 's/Port 22/Port 12345/g' /etc/ssh/sshd_config
#    service ssh restart
#fi

#################################
### GRASS compilation dependecies
#################################
apt-get install --yes flex bison libproj-dev libtiff-dev mesa-common-dev libglu1-mesa-dev libfftw3-dev libblas-dev liblapack-dev \
    libcairo-dev proj-bin libgdal1-dev libwxbase2.8-dev git gettext subversion emacs23-nox g++ python-numpy gdal-bin make

dir=/mnt/home/gislab
og=gislab:gislabusers
if [ ! -d $dir/src ]; then
    mkdir $dir/src
    cd $dir/src
    svn co http://svn.osgeo.org/grass/grass/trunk grass_71
    chown $og $dir/src -R
fi

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
    
    schema_priv public gislabusers
    schema_priv dibavod gislabusers
    schema_priv osm gislabusers
    schema_priv rastry gislabusers
    schema_priv ruian gislabusers
    schema_priv ruian_praha gislabusers
    
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

    cd /opt/gislab/system/accounts/skel/.grassdata/
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
    homedir=/mnt/home/gislab
    gitdir="dataset"
    if [ ! -d ${homedir}/${gitdir} ] ; then
        cd $homedir
        git clone https://github.com/GISMentors/${gitdir}.git
    else
        cd ${homedir}/${gitdir}
        git pull
    fi
    
    datadir=/mnt/repository/gismentors
    rm -rf $datadir && mkdir $datadir
    
    ${homedir}/${gitdir}/postgis/export_shp.sh
    mv /tmp/gismentors_shp $datadir/shp

    cd $datadir
    if [ ! -f dmt.tif ] ; then
        wget http://training.gismentors.eu/geodata/eu-dem/dmt.zip
        unzip dmt.zip
    fi

    if [ ! -d txt ] ; then
        mkdir txt && cd txt
        wget https://github.com/GISMentors/qgis-zacatecnik/files/39270/export.txt
        wget https://github.com/GISMentors/qgis-zacatecnik/files/39271/xy_data.txt
    fi
}

gismentors_data

exit 0
