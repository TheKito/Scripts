#!/bin/bash
#No Changes Alarm
STR=/Storage/Master/
ALMTMP=/tmp/ALM
cat /dev/null > $ALMTMP.err
cat /dev/null > $ALMTMP.log
for d in $STR/*; do
        DEV=$(basename $d)
        LOG=/tmp/$DEV.log
        find "$d" -mtime -2 -ls > $LOG
        [ -s $LOG ] && echo "    OK     $DEV" >> $ALMTMP.log
        [ -s $LOG ] || echo "   ERROR   $DEV" >> $ALMTMP.err
done
cat $ALMTMP.err $ALMTMP.log
cat $ALMTMP.err $ALMTMP.log | mutt -s "BackUp Server $(hostname)" $(hostname)@$(cat /etc/mailname)

sleep 86400
