#!/bin/sh

if test -z $1 ; then
    echo "usage: $0 backup_name"
    exit 1
fi

image=/mnt/backup/client-desktop-image-$1
root=/mnt/backup/client-desktop-root-${1}.tar.bz2

echo "Recovering $root..."
sudo rm -r /opt/gislab/system/clients/desktop/root
sudo tar xjf $root -C /

echo "Recovering $image..."
sudo rm -r /opt/gislab/system/clients/desktop/image
sudo cp -a $image /opt/gislab/system/clients/desktop/image

exit 0
