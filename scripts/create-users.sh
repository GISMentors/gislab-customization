#!/bin/sh

if test -z "$1" ; then
    echo "usage: $0 file.csv"
    exit 1
fi

tail -n +3 $1 | while read line || [ -n "$line" ];
do           
    fname=`echo $line | cut -d ';' -f2 | iconv -f utf-8 -t us-ascii//TRANSLIT`
    sname=`echo $line | cut -d ';' -f1 | iconv -f utf-8 -t us-ascii//TRANSLIT `
    name=`echo $sname | iconv -f utf-8 -t us-ascii//TRANSLIT | tr '[:upper:]' '[:lower:]'`
    passwd=`echo $fname | iconv -f utf-8 -t us-ascii//TRANSLIT | tr '[:upper:]' '[:lower:]'`
    mail="$name@gislab.fsv.cvut.cz"

    if [ "$2" = "d" ]; then
	echo sudo gislab-deluser -f $name
    fi
    echo sudo gislab-adduser -g $fname -l $sname -m $mail -p ${passwd} $name
done
if [ "$2" = "d" ]; then
    echo sudo gislab-deluser -f landa
fi
echo sudo gislab-adduser -g Martin -l Landa -m landa@gislab.fsv.cvut.cz -p martin landa

exit 0
