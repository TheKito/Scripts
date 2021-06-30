#!/bin/bash
HOST=$1
NAME=$(echo "$HOST" | cut -d "." -f1)

ssh-copy-id $HOST
ssh $HOST  "apt-get update && apt-get install rsync -y"

SRC=$1:/
DST=/Storage/Master/$NAME/
HST=/Storage/History/$(date "+%Y/%m/%d/%H")/$NAME/

echo SRC: $SRC
echo DST: $DST
echo HST: $HST

mkdir -p "$DST" && \
mkdir -p "$HST" && \
rsync -arv --exclude={"/var/lib/mlocate","/var/mail","/var/log","/var/lib/ispell","/var/lib/dpkg","/var/lib/apt","/var/cache","/bin","/boot","/dev","/initrd*","/lib*","/mount","/sbin","/srv","/usr","vmlinuz*","/proc","/sys","/tmp","/run","/mnt","/media","/lost+found","/Storage"} --progress --delete-after --delete -b --backup-dir="$HST" "$SRC" "$DST" && \
sleep 3600