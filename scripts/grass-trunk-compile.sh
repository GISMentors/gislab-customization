#!/bin/sh
set -e

TARGET=/opt/gislab/system/clients/desktop/root/usr/local
VERSION=7.1.svn
MAJOR=71

cd /mnt/home/gislab/src/grass_$MAJOR
svn up
if [ -f include/Make/Platform.make ] ; then
    make distclean
fi
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

rm -rf $TARGET/grass-$VERSION
cp -a /usr/local/grass-$VERSION $TARGET
cp -a /usr/local/bin/grass$MAJOR $TARGET/bin

exit 0
