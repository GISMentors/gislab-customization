#!/bin/sh
#set -e

TARGET=/opt/gislab/system/clients/desktop/root/usr/local
GRASS_VERSION=7.1.svn
GRASS_MAJOR=71

grass() {
    cd /mnt/home/gislab/src/grass_$GRASS_MAJOR
    svn up
#    if [ -f include/Make/Platform.make ] ; then
#	make distclean
#    fi
    ./configure \
	--prefix=/usr/local \
	--with-postgres --with-postgres-includes=/usr/include/postgresql \
	--with-gdal --with-proj \
	--with-nls \
	--with-cxx --enable-largefile \
	--with-freetype --with-freetype-includes=/usr/include/freetype2 \
	--with-sqlite \
	--with-cairo --with-python \
	--with-geos --with-pthread --with-lapack --with-blas
    
    make -j2
    make install

    rm -rf $TARGET/grass-$GRASS_VERSION
    cp -a /usr/local/grass-$GRASS_VERSION $TARGET
    cp -a /usr/local/bin/grass$GRASS_MAJOR $TARGET/bin

    echo "/usr/local/grass-$GRASS_VERSION/lib" > /etc/ld.so.conf.d/grass.conf
    echo "/usr/local/grass-$GRASS_VERSION/lib" > ${TARGET}/../../etc/ld.so.conf.d/grass.conf
    
}

gdal() {
    cd /mnt/home/gislab/src/gdal_20
    svn up
    ./configure --prefix=$1 --with-sqlite3 \
		--with-grass=$TARGET/grass-$GRASS_VERSION \
                --with-spatialite
    make -j2
    make install
}

geos() {
    cd /mnt/home/gislab/src/geos_35
    svn up
    ./autogen.sh
    ./configure --prefix=$1
    make -j2
    make install
}

qgis() {
    cd /mnt/home/gislab/src/qgis_214
    rm -rf build
    mkdir build
    cd build
    cmake -D GRASS_PREFIX7=$TARGET/grass-$GRASS_VERSION \
          -D WITH_BINDINGS=ON \
          -D WITH_GRASS7=ON \
          -D QT_QMAKE_EXECUTABLE=/usr/share/qt4/bin/qmake \
	  -D CMAKE_BUILD_TYPE=Release \
	  -D WITH_STAGED_PLUGINS=FALSE \
	  -D CMAKE_INSTALL_PREFIX=$TARGET \
	  ..
    make -j2
    make install
}

proj() {
    cd /mnt/home/gislab/src/proj_49
    git pull
    ./autogen.sh
    ./configure --prefix=$1
    make -j2
    make install
}

cmake() {
    cd /mnt/home/gislab/src/cmake_35
    ./configure --prefix=/usr/local
    make -j2
    make install
}

proj /usr/local
proj $TARGET
gdal /usr/local
gdal $TARGET
geos /usr/local
geos $TARGET
grass
cmake
qgis

ldconfig
gislab-client-shell ldconfig
exit 0
