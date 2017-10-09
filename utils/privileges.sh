#!/bin/bash

if [ -n "$1" ] ; then
    DB="$1"
else
    DB="gismentors"
fi
USER="postgres"

function grant_priv() {
    echo "GRANT USAGE on SCHEMA $1 to gislabusers;
    GRANT SELECT ON ALL TABLES IN SCHEMA $1 TO gislabusers;" |
        sudo psql -U $USER $DB
}

schemas=`sudo psql -U $USER $DB -c"\dn" -A -t | cut -d'|' -f1`

# grant privileges
for schema in $schemas; do
    echo "Schema $schema..."
    grant_priv $schema
done

# revoke priviliges on public
echo "Revoke..."
echo "REVOKE CREATE ON SCHEMA public FROM gislabusers;
REVOKE ALL ON SCHEMA public FROM gislabusers;" |
    sudo psql -U $USER $DB

# revoke privileges on database
echo "REVOKE CREATE ON DATABASE $DB FROM gislabusers;" |
    sudo psql -U $USER $DB
