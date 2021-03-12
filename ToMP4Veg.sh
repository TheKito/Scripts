#!/bin/sh
SRC="$1"
EXT=${SRC##*.}
DST=${SRC%.$EXT}.mp4
[ "$SRC" = "$DST" ] && exit
rm "$DST" 2> /dev/null
echo "===========================Re-Encoding==========================="
echo "Source: $SRC"
echo "Destination: $DST"
echo "================================================================="
/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -c:a aac -strict experimental -vf yadif=1 -channel_layout stereo -tune fastdecode -pix_fmt yuv420p -b:a 192k -ar 48000  "$DST" && \
(touch -d @$(stat -c "%Y" "$SRC") "$DST")  &&  \
rm -v "$SRC"

#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264  "$DST.test1.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -crf 1 "$DST.test2.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -tune fastdecode "$DST.test3.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -pix_fmt yuv420p  "$DST.test4.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -pix_fmt yuv420p -c:a aac "$DST.test5.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -pix_fmt yuv420p -c:a aac -ar 48000 "$DST.test6.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -pix_fmt yuv420p -c:a aac -ar 48000 -b:a 192k "$DST.test7.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -pix_fmt yuv420p -c:a aac -ar 48000 -b:a 192k -tune fastdecode "$DST.test8.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -pix_fmt yuv420p -c:a aac -ar 48000 -b:a 192k -tune fastdecode -strict experimental "$DST.test9.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -c:a aac -strict experimental -tune fastdecode -pix_fmt yuv420p -b:a 192k -ar 48000  "$DST.test10.mp4"
#/usr/bin/ffmpeg -i "$SRC"  -c:v libx264 -c:a aac -strict experimental -channel_layout stereo -tune fastdecode -pix_fmt yuv420p -b:a 192k -ar 48000  "$DST.test11.mp4"
