#!/bin/sh

for n in `seq 1 21`; do
    if [ $n -lt 10 ] ; then
	num="0$n"
    else
	num="$n"
    fi
    user=pc$num
    sudo rm -f /mnt/home/${user}/.gislab/session.lock
    sudo gislab-deluser -f $user
    sudo gislab-adduser -g PC-$num -l B870 -m $user@gislab.fsv.cvut.cz -p b870 $user
done

exit 0
