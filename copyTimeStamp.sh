#!/bin/bash
if [ ! -f "$1" ] ; then
        echo "usage: copyTimeStamp <sourcefile> <destfile>"
        exit 1
fi
if [ ! -f "$2" ] ; then
        echo "usage: copyTimeStamp <sourcefile> <destfile>"
        exit 2
fi

touch -d @$(stat -c "%Y" "$1") "$2"
