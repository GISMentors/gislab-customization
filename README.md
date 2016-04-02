# GIS.lab customization for GISMentors training

GIS.lab: http://web.gislab.io/

## Usage

        ansible-playbook -inventory-file=gislab-unit-gismentors.inventory \
        --private-key=/path/to/your/private/key \
        gislab-server-customize.yml
   
        ansible-playbook -inventory-file=gislab-unit-gismentors.inventory \
        --private-key=/path/to/your/private/key \
        gislab-grass-trunk.yml
   
        ansible-playbook -inventory-file=gislab-unit-gismentors.inventory \
        --private-key=/path/to/your/private/key \
        gislab-client-customize.yml

## Packaging Notes

See https://github.com/imincik/imincik-pkg-doc

    OTHERMIRROR="deb http://ppa.launchpad.net/imincik/general/ubuntu $DIST main | deb http://ppa.launchpad.net/imincik/gis-dev/ubuntu $DIST main | deb http://ppa.launchpad.net/landa-martin/gislab-gismentors/ubuntu $DIST main "
    
    export DIST=precise
    sudo -E cowbuilder --create --distribution=$DIST --basepath=/var/cache/pbuilder/base-${DIST}-gislab.cow --save-after-login

### GEOS 3.5.0

    git clone http://anonscm.debian.org/cgit/pkg-grass/geos.git pkg-geos
    cd pkg-geos
    git checkout -b gislab origin/experimental
    dch -v 3.5.0-2~precise1
    git commit -am"GIS.lab release"
    gbp buildpackage -d -S -sa --git-pbuilder --git-dist=precise-gislab-gismentors --git-ignore-new
    debsign ../geos_3.5.0-2~precise1_source.changes
    dput ppa:landa-martin/gislab-gismentors ../geos_3.5.0-2~precise1_source.changes
    
### GDAL 2.0

    git clone http://anonscm.debian.org/cgit/pkg-grass/gdal.git pkg-gdal
    cd pkg-gdal
    git checkout -b gislab origin/experimental-2.0
    sed -i 's/experimental-2.0/gislab/g' debian/gbp.conf
    dch -v 2.0.2-1~precise1
    git commit -am"GIS.lab release"
    gbp buildpackage -d -S -sa --git-pbuilder --git-dist=precise-gislab-gismentors --git-ignore-new
    debsign ../gdal_2.0.2+dfsg-1~precise1_source.changes
    dput ppa:landa-martin/gislab-gismentors ../gdal_2.0.2+dfsg-1~precise1_source.changes

### GRASS GIS 7.1

    export REV=r68175
    
    mkdir pkg-grass
    dget https://launchpad.net/~grass/+archive/ubuntu/grass-devel/+files/grass-daily_7.1.svn-1-${REV}~ubuntu12.04.1.dsc
    cd pkg-grass
    git init
        
    gbp import-dsc ../grass-daily_7.1.svn-1-${REV}~ubuntu12.04.1.dsc
    gbp import-orig ../grass-daily_7.1.svn-1-${REV}~ubuntu12.04.1.tar.gz
    emacs debian/changelog -nw
    git commit -am"GIS.lab release"
    gbp buildpackage -d -S -sa --git-pbuilder --git-dist=precise-gislab-gismentors --git-ignore-new
    debsign ../grass-daily_7.1.svn-2-${REV}~ubuntu12.04.1_source.changes
    dput ppa:landa-martin/gislab-gismentors ../grass-daily_7.1.svn-2-${REV}~ubuntu12.04.1_source.changes

### QGIS 2.14

    git clone http://anonscm.debian.org/cgit/pkg-grass/qgis.git pkg-qgis
    cd pkg-qgis
    git checkout -b gislab origin/upstream-ltr
    dch -v 2.14.0+dfsg-1~precise1
    git commit -am"GIS.lab release"
    debuild -S -sa -i -I
    dput ppa:landa-martin/gislab-gismentors ../qgis_2.14.0+dfsg-1~precise1_source.changes

or

    git clone https://github.com/qgis/QGIS.git
    cd QGIS
    git checkout release-2_8

    QGISVERSION=2.8.7

    DATE=$(date +%Y%m%d)
    CHANGESET=$(git rev-parse --short HEAD)
    DEBVERSION=+git$DATE~$CHANGESET~precise

    dch --newversion "${QGISVERSION}-1${DEBVERSION}1" "New release."
    git add debian/changelog
    git ci -m "Debian changelog update."

    debuild -S -sa -i -I
    dput ppa:landa-martin/gislab-testing ../qgis_${QGISVERSION}-1${DEBVERSION}1_source.changes
    