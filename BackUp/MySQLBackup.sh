#!/bin/bash

HOST=$1
USER=$2
PASS=$3

FOLD=/home/$HOST/MySQL

mkdir -p "$FOLD"

for db in $(mysql -NBA -h $HOST -u $USER -p$PASS -e 'show databases;' | grep -v information_schema)
do
        echo Data Base $db
        FOLD_DB="$FOLD/$db"
        mkdir -p "$FOLD_DB"

        for tab in $(mysql -NBA -h $HOST -u $USER -p$PASS -D $db -e 'show tables;')
        do
                echo Table $tab
                FILE_TBL="$FOLD_DB/$tab"
                mysqldump -d --skip-triggers -h $HOST -u $USER -p$PASS $db $tab > "$FILE_TBL.schema.sql"
                mysqldump --skip-triggers --compact --no-create-info -h $HOST -u $USER -p$PASS $db $tab | gzip >  "$FILE_TBL.data.sql.gz"
        done

        echo $db
done
