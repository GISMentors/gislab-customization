#!/bin/sh

tar cjf /mnt/backup/client-desktop-root-`date -I`.tar.bz2 \
    /opt/gislab/system/clients/desktop/root
cp -a /opt/gislab/system/clients/desktop/image \
   /mnt/backup/client-desktop-image-`date -I`

exit 0
