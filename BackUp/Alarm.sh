#!/bin/bash
#No Changes Alarm
STR=/Storage/Master/
ALMTMP=/tmp/ALM
cat /dev/null > $ALMTMP.err
cat /dev/null > $ALMTMP.log
cat /dev/null > $ALMTMP.ext
for d in $STR/*; do
        DEV=$(basename $d)
        LOG=/tmp/$DEV.log
        find "$d" -type f -mtime -2 -ls > $LOG
        [ -s $LOG ] && echo "    OK     $DEV" >> $ALMTMP.log
        [ -s $LOG ] || echo "   ERROR   $DEV" >> $ALMTMP.err
		echo "" >> $ALMTMP.ext
		echo "" >> $ALMTMP.ext
		echo ==== $DEV ==== >> $ALMTMP.ext
		cat $LOG >> $ALMTMP.ext
		echo "==========================================================" >> $ALMTMP.ext
done
cat $ALMTMP.err $ALMTMP.log $ALMTMP.ext
cat $ALMTMP.err $ALMTMP.log $ALMTMP.ext | mutt -s "BackUp Server $(hostname)" $(hostname)@$(cat /etc/mailname)

sleep 86400
