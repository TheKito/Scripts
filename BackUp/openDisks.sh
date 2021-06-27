#!/bin/bash
read KEYSTRING

DISKTOMOUNT=( $( blkid | grep LUKS | cut --fields=1 --delimiter=: ) )

for ITEM in ${DISKTOMOUNT[*]}
do
      echo "LUKS device: $ITEM"

      DEVICENAME="${ITEM#/dev/}"
      echo "LUKS device name: $DEVICENAME"

      echo "Open disk"
      echo $KEYSTRING | cryptsetup luksOpen /dev/$DEVICENAME $DEVICENAME-crypt
done

mount -a
