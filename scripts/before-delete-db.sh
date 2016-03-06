#!/bin/sh

drop_schema() {
    if [ ! -z `sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -w $1` ]; then
        sudo -u postgres psql $1 -c"drop schema $GISLAB_USER cascade"
    fi
}

drop_schema gismentors

exit 0