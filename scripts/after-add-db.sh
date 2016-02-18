#!/bin/sh

create_schema() {
    if [ ! -z `sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -w $1` ]; then
        echo "CREATE SCHEMA $GISLAB_USER;
GRANT USAGE on SCHEMA $GISLAB_USER to $GISLAB_USER;
GRANT SELECT ON ALL TABLES IN SCHEMA $GISLAB_USER TO $GISLAB_USER;
GRANT all ON SCHEMA $GISLAB_USER to $GISLAB_USER" | \
            sudo -u postgres psql $1
    fi
}

create_schema gismentors
    
exit 0
