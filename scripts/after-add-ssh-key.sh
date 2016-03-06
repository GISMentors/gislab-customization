#!/bin/sh

mkdir /mnt/home/${GISLAB_USER}/.ssh
cp /mnt/home/gislab/.ssh/id_rsa.pub /mnt/home/${GISLAB_USER}/.ssh/authorized_keys
chown ${GISLAB_USER}:gislabusers /mnt/home/${GISLAB_USER}/.ssh/ -R

exit 0
