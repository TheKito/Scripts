#!/bin/bash
HOST=$1
NAME=$(echo "$HOST" | cut -d "." -f1)

ssh-copy-id $HOST
ssh $HOST  "apt-get update && apt-get install rsync -y"

SRC=$1:/Data/
DST=/Storage/Master/$NAME/Data/
HST=/Storage/History/$(date "+%Y/%m/%d/%H")/$NAME/Data/

echo SRC: $SRC
echo DST: $DST
echo HST: $HST

mkdir -p "$DST" && \
mkdir -p "$HST" && \
rsync -arv --progress --delete-after --delete -b --backup-dir="$HST" "$SRC" "$DST" && \
sleep 3600
