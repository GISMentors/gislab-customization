#!/bin/sh
set -e

apt-get install --yes git emacs23-nox gdal-bin

homedir=/mnt/home/gislab

clone_git() {
    gitdir=$1
    if [ ! -d ${homedir}/${gitdir} ] ; then
        cd $homedir
        git clone https://github.com/GISMentors/${gitdir}.git
    else
        cd ${homedir}/${gitdir}
        git pull
    fi
}

clone_git dataset
clone_git gislab-customization

#######################
### Change SSH port ###
#######################
#is_unit=`grep GISLAB_UNIQUE_ID /etc/gislab_version | grep gislab-unit | wc -l`
#if [ $is_unit -eq 1 ] ; then
#    sed -i 's/Port 22/Port 12345/g' /etc/ssh/sshd_config
#    service ssh restart
#fi

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
        #return
    fi
    createdb -U postgres $db
    pg_restore /mnt/repository/$db.dump | psql -U postgres $db
    ${homedir}/dataset/postgis/epsg-5514.sh
    
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
        wget http://training.gismentors.eu/geodata/grass/modis.zip
    fi

    cd /opt/gislab/system/accounts/skel
    if [ -d .grassdata ] ; then
        mv .grassdata grassdata
        sed -i 's/\.grassdata/grassdata/g' /opt/gislab/system/accounts/skel/.grass7/rc
    fi
    cd grassdata
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
    sh -c 'echo "export GDAL_DATA=/usr/local/share/gdal" >> bashrc'
    sed -i 's/\.grassdata/grassdata/g' rc
    sed -i 's/world/gismentors/g' rc
}

gismentors_grass

###################
### GISMentors data
###################
gismentors_data() {
    datadir=/mnt/repository/gismentors
    if [ -d $datadir ] ; then
        return
    fi

    mkdir $datadir
    cd $datadir
    if [ ! -d shp ] ; then
        ${homedir}/dataset/postgis/export_shp.sh
        mv /tmp/gismentors_shp shp
    fi
    
    if [ ! -f dmt.tif ] ; then
        wget http://training.gismentors.eu/geodata/eu-dem/dmt.zip
        unzip dmt.zip
        rm dmt.zip
    fi
    if [ ! -f dmt100.tif ] ; then
        gdalwarp -t_srs EPSG:5514 -r cubic -tr 100 100 dmt.tif dmt100.tif
    fi

    if [ ! -d txt ] ; then
        (mkdir txt && cd txt;
        wget https://github.com/GISMentors/qgis-zacatecnik/files/39270/export.txt;
        wget https://github.com/GISMentors/qgis-zacatecnik/files/39271/xy_data.txt)
    fi

    if [ ! -d foto ] ; then
        wget https://github.com/GISMentors/dataset/raw/master/odvozena_data/WP_20160403.tar.bz2
        tar xjf WP_20160403.tar.bz2
        rm WP_20160403.tar.bz2
    fi

    if [ ! -d krim ] ; then
        wget https://github.com/GISMentors/dataset/raw/master/odvozena_data/vusc_krim.tar.gz
        tar xvf vusc_krim.tar.gz
        rm vusc_krim.tar.gz
    fi

    if [ ! -d dopr_znaceni ] ; then
        wget https://github.com/GISMentors/dataset/raw/master/odvozena_data/dopr_znaceni.tar.gz
        tar xzf dopr_znaceni.tar.gz
        rm dopr_znaceni.tar.gz
    fi

    if [ ! -d rastry_georef ] ; then
        wget https://github.com/GISMentors/dataset/raw/master/odvozena_data/rastry_georef.tar.gz
        tar xzf rastry_georef.tar.gz
        rm rastry_georef.tar.gz
    fi

    if [ ! -d vusc-diag ] ; then
        wget https://github.com/GISMentors/dataset/raw/master/odvozena_data/vusc-diag.tar.gz
        tar xzf vusc-diag.tar.gz
        rm vusc-diag.tar.gz
        wget https://github.com/GISMentors/dataset/raw/master/odvozena_data/vusc-silnice-projekt.qgs
    fi

    if [ ! -d geopython ] ; then
        wget http://training.gismentors.eu/geodata/geopython/data.tgz
        tar xvzf data.tgz
        mv data geopython
        rm data.tgz
    fi
}

gismentors_data

exit 0
