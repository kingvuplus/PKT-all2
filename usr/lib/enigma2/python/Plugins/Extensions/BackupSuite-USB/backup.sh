#!/bin/sh
if tty > /dev/null ; then
   RED='-e \e[00;31m'
   GREEN='-e \e[00;32m'
   YELLOW='-e \e[01;33m'
   BLUE='-e \e[00;34m'
   PURPLE='-e \e[01;31m'
   WHITE='-e \e[00;37m'
else
   RED='\c00??0000'
   GREEN='\c0000??00'
   YELLOW='\c00????00'
   BLUE='\c0000????'
   PURPLE='\c00?:55>7'
   WHITE='\c00??????'
fi
export LANG=$1
export HARDDISK=0
export SHOW="python /usr/lib/enigma2/python/Plugins/Extensions/BackupSuite-HDD/message.py $LANG"
TARGET="XX"
USEDSIZE=`df -k /usr/ | grep [0-9]% | tr -s " " | cut -d " " -f 3` # size of rootfs
NEEDEDSPACE=$(((4*$USEDSIZE)/1024))
for candidate in /media/*
do
	if [ -f "${candidate}/"*[Bb][Aa][Cc][Kk][Uu][Pp][Ss][Tt][Ii][Cc][Kk]* ]
	then
	TARGET="${candidate}"
	fi 
done

if [ "$TARGET" = "XX" ] ; then
	echo -n $RED
	$SHOW "message21" #error about no USB-found
	echo -n $WHITE
else
	echo -n $YELLOW
	$SHOW "message22" 
	SIZE_1="$(df -h "$TARGET" | tail -n 1 | awk {'print $4'})"
	SIZE_2="$(df -h "$TARGET" | tail -n 1 | awk {'print $2'})"
	echo -n " -> $TARGET ($SIZE_2, " ; $SHOW "message16" ; echo "$SIZE_1)"
	FREESIZE="$(df -B 1048576 "$TARGET" | tail -n 1 | awk {'print $4'})"
	if [ $FREESIZE -lt $NEEDEDSPACE ] ; then
		echo $RED
		echo "      * * * W A R N I N G * * * "
		echo "Not enough free space on $TARGET to make a back-up"
		echo -n "Free space   = " ; printf '%5s' $FREESIZE; echo ' MB'
		echo -n "Needed space = " ; printf '%5s' $NEEDEDSPACE; echo ' MB'
		echo " "
		echo "The program will abort, please try another media for your back-up"
		echo $WHITE
		exit 0
	fi
	/usr/lib/enigma2/python/Plugins/Extensions/BackupSuite-HDD/backupsuite.sh "$TARGET" 
	sync
fi
