
#       FULL BACKUP UYILITY FOR ENIGMA2/OPENPLI, SUPPORTS THE MODELS          #
#      Clark Tech/Xtrend etXX00, all models VU+ and MK-Digital XP1000         #
#                   MAKES A FULLBACK-UP READY FOR FLASHING.                   #
#                   Pedro_Newbie (backupsuite@outlook.com)                    #
###############################################################################
#
#!/bin/sh

##TESTING IF PROGRAM IS RUN FROM COMMANDLINE OR CONSOLE, JUST FOR THE COLORS ##
if tty > /dev/null ; then		# Commandline
	RED='-e \e[00;31m'
	GREEN='-e \e[00;32m'
	YELLOW='-e \e[01;33m'
	BLUE='-e \e[01;34m'
	PURPLE='-e \e[01;31m'
	WHITE='-e \e[00;37m'
else							# On the STB
	RED='\c00??0000'
	GREEN='\c0000??00'
	YELLOW='\c00????00'
	BLUE='\c0000????'
	PURPLE='\c00?:55>7'   
	WHITE='\c00??????'
fi
###################### FIRST DEFINE SOME PROGRAM BLOCKS #######################
########################## DEFINE CLEAN-UP ROUTINE ############################
clean_up()
{
umount /tmp/bi/root > /dev/null 2>&1
rmdir /tmp/bi/root > /dev/null 2>&1
rmdir /tmp/bi > /dev/null 2>&1
rm -rf "$WORKDIR" > /dev/null 2>&1
}

###################### BIG OOPS!, HOLY SH... (SHELL SCRIPT :-))################
big_fail()
{
clean_up
echo -n $RED
$SHOW "message15" 2>&1 | tee -a $LOGFILE # Image creation FAILED!
echo $WHITE
exit 0
}

############################ DEFINE IMAGE_VERSION #############################
image_version()
{
echo "Back-up date       = $BACKUPDATE"
echo "Image version      = $IMVER"
echo "Installed/flashed  = $FLASHED"
echo "Image last updated = $LASTUPDATE"
echo $LINE
}

#################### CLEAN UP AND MAKE DESTINATION FOLDERS ####################
make_folders()
{
rm -rf "$MAINDEST"
echo "Removed directory  = $MAINDEST"  >> $LOGFILE
mkdir -p "$MAINDEST"
echo "Created directory  = $MAINDEST"  >> $LOGFILE
}

################### BACK-UP MADE AND REPORTING SIZE ETC. ######################
backup_made()
{
{
echo $LINE
$SHOW "message10" ; echo "$MAINDEST" 	# USB Image created in: 
$SHOW "message23"		# "The content of the folder is:"
ls "$MAINDEST" -e1rSh | sed 's/-r.....r..    1//' 
echo $LINE
$SHOW "message11" ; echo "$EXTRA"		# and there is made an extra copy in:
echo $LINE
} 2>&1 | tee -a $LOGFILE
}

############################## END PROGRAM BLOCKS #############################

########################## DECLARATION OF VARIABLES ###########################
BACKUPDATE=`date +%Y.%m.%d_%H:%M`
DATE=`date +%Y%m%d_%H%M`
ESTSPEED=`cat /usr/lib/enigma2/python/Plugins/Extensions/BackupSuite-HDD/speed.txt`
FLASHED=`date -r /etc/version +%Y.%m.%d_%H:%M`
ISSUE=`cat /etc/issue | grep . | tail -n 1 ` 
IMVER=${ISSUE%?????}
LASTUPDATE=`date -r /var/lib/opkg/status +%Y.%m.%d_%H:%M`
LOGFILE=/tmp/BackupSuite.log
MEDIA="$1"
MKFS=/usr/sbin/mkfs.ubifs
NANDDUMP=/usr/sbin/nanddump
START=$(date +%s)
TARGET="XX"
UBINIZE=/usr/sbin/ubinize
UBINIZE_ARGS="-m 2048 -p 128KiB"
USEDsizebytes=`df -B 1 /usr/ | grep [0-9]% | tr -s " " | cut -d " " -f 3`
USEDsizekb=`df -k /usr/ | grep [0-9]% | tr -s " " | cut -d " " -f 3` 
VERSION="Version 14.9 - 17-02-2014"
WORKDIR="$MEDIA/bi"

######################### START THE LOGFILE $LOGFILE ##########################
echo "*** THIS BACKUP IS CREATED WITH THE PLUGIN BACKUPSUITE ***" > $LOGFILE
echo "***** This plugin is brought to you by Pedro_Newbie ******" >> $LOGFILE
echo $LINE >> $LOGFILE
echo "Plugin version     = $VERSION" >> $LOGFILE
echo "Back-up media      = $MEDIA" >> $LOGFILE
df -h "$MEDIA"  >> $LOGFILE
echo $LINE >> $LOGFILE
image_version >> $LOGFILE
echo "Working directory  = $WORKDIR" >> $LOGFILE

######################### TESTING FOR UBIFS OR JFFS2 ##########################
grep rootfs /proc/mounts | grep -q ubifs 
if [ "$?" = 1 ] ; then
	echo $RED
	$SHOW "message01" 2>&1 | tee -a $LOGFILE #NO UBIFS, THEN JFFS2 BUT NOT SUPPORTED ANYMORE
	big_fail
fi

####### TESTING IF ALL THE TOOLS FOR THE BUILDING PROCESS ARE PRESENT #########
echo $RED
if [ ! -f $NANDDUMP ] ; then
	{
	echo -n "$NANDDUMP " ; $SHOW "message05"  	# nanddump not found.
	} 2>&1 | tee -a $LOGFILE
	big_fail
fi
if [ ! -f $MKFS ] ; then
	{
	echo -n "$MKFS " ; $SHOW "message05"  		# mkfs.ubifs not found.
	} 2>&1 | tee -a $LOGFILE
	big_fail
fi
if [ ! -f $UBINIZE ] ; then
	{
	echo -n "$UBINIZE " ; $SHOW "message05"  	# ubinize not found.
	} 2>&1 | tee -a $LOGFILE
	big_fail
fi
echo -n $WHITE


########## TESTING WHICH BRAND AND MODEL SATELLITE RECEIVER IS USED ###########
#------------------------------------------------------------------------------
####################### XTREND/CLARK TECH AND XP MODELS #######################
if [ -f /proc/stb/info/boxtype ] ; then
	MODEL=$( cat /proc/stb/info/boxtype )
	MKUBIFS_ARGS="-m 2048 -e 126976 -c 4096"
	if grep et /proc/stb/info/boxtype > /dev/null ; then
		TYPE=ET
		SHOWNAME="Xtrend $MODEL"
		if [ $MODEL = "et10000" -o $MODEL = "et8000" ] ; then 
			MKUBIFS_ARGS="-m 2048 -e 126976 -c 8192"
		else
			MODEL=${MODEL:0:3}x00
		fi
		MAINDEST="$MEDIA/$MODEL"
		EXTRA="$MEDIA/fullbackup_$MODEL/$DATE"
		echo "Destination        = $MAINDEST" >> $LOGFILE
		echo $LINE >> $LOGFILE
	elif grep xp /proc/stb/info/boxtype > /dev/null ; then
		TYPE=XP
		SHOWNAME="MK-Digital $MODEL"
		MODEL="${MODEL:0:6}"	# Stripping the S from the modelname so xp1000s becomes xp1000
		MAINDEST="$MEDIA/$MODEL"
		EXTRA="$MEDIA/fullbackup_$MODEL/$DATE"
		echo "Destination        = $MAINDEST" >> $LOGFILE
		echo $LINE >> $LOGFILE
	elif grep ini /proc/stb/info/boxtype > /dev/null ; then
		if [ $MODEL = "ini-9000de" ]; then
			TYPE=XP
			MKUBIFS_ARGS="-m 4096 -e 1040384 -c 1984"
			UBINIZE_ARGS="-m 4096 -p 1024KiB"
			MODEL="xpeedlx3"
			SHOWNAME="GI $MODEL"
			MAINDEST="$MEDIA/$MODEL"
			EXTRA="$MEDIA/fullbackup_$MODEL/$DATE"
			echo "Destination        = $MAINDEST" >> $LOGFILE
			echo $LINE >> $LOGFILE		
		else
			TYPE=XP
			MODEL="xpeedlx"
			SHOWNAME="GI $MODEL"
			MAINDEST="$MEDIA/$MODEL"
			EXTRA="$MEDIA/fullbackup_$MODEL/$DATE"
			echo "Destination        = $MAINDEST" >> $LOGFILE
			echo $LINE >> $LOGFILE
		fi
	else
		echo $RED
		$SHOW "message01" 2>&1 | tee -a $LOGFILE # No supported receiver found!
		big_fail
	fi

	################################ VU+ MODELS ###############################
elif [ -f /proc/stb/info/vumodel ] ; then
	MODEL=$( cat /proc/stb/info/vumodel )
	TYPE=VU
	MKUBIFS_ARGS="-m 2048 -e 126976 -c 4096 -F"
	SHOWNAME="Vu+ $MODEL"
	MAINDEST="$MEDIA/vuplus/$MODEL"
	EXTRA="$MEDIA/fullbackup_$MODEL/$DATE/vuplus"
	echo "Destination        = $MAINDEST" >> $LOGFILE
	echo $LINE >> $LOGFILE
	
	######################### NO SUPPORTED RECEIVER FOUND #####################
else
	echo $RED
	$SHOW "message01" 2>&1 | tee -a $LOGFILE # No supported receiver found!
	big_fail
fi
######### END TESTING WHICH BRAND AND MODEL SATELLITE RECEIVER IS USED ########

############# START TO SHOW SOME INFORMATION ABOUT BRAND & MODEL ##############
echo -n $PURPLE
echo -n "$SHOWNAME " | tr  a-z A-Z	# Shows the receiver brand and model
$SHOW "message02"  					# BACK-UP TOOL FOR MAKING A COMPLETE BACK-UP 

echo $BLUE
echo "$VERSION"
echo "Pedro_Newbie (e-mail: backupsuite@outlook.com) mod PKT"
echo $WHITE

###################### CALCULATE SIZE AND ESTIMATED SPEED ######################

$SHOW "message06" 	#"Some information about the task:"
if [ $MODEL = "solo2" ] || [ $MODEL = "duo2" ] || [ $MODEL = "xpeedlx" ] || [ $MODEL = "xpeedlx3" ]; then
	KERNELHEX=`cat /proc/mtd | grep mtd2 | cut -d " " -f 2`
else 
	KERNELHEX=`cat /proc/mtd | grep mtd1 | cut -d " " -f 2`
fi
KERNEL=$((0x$KERNELHEX))
TOTAL=$(($USEDsizebytes+$KERNEL))
KILOBYTES=$(($TOTAL/1024))
MEGABYTES=$(($KILOBYTES/1024))
{
echo -n "KERNEL" ; $SHOW "message04" ; printf '%7s' $(($KERNEL/1024)); echo ' KB'
echo -n "ROOTFS" ; $SHOW "message04" ; printf '%7s' $USEDsizekb; echo ' KB'
echo -n "=TOTAL" ; $SHOW "message04" ; printf '%7s' $KILOBYTES; echo " KB (= $MEGABYTES MB)"
} 2>&1 | tee -a $LOGFILE

ESTTIMESEC=$(($KILOBYTES/$ESTSPEED))
ESTMINUTES=$(( $ESTTIMESEC/60 ))
ESTSECONDS=$(( $ESTTIMESEC-(( 60*$ESTMINUTES ))))
if [ $ESTSECONDS -le  9 ] ; then 
	ESTSECONDS="0$ESTSECONDS"
fi
echo $LINE
####### WARNING IF THE IMAGESIZE OF THE XTRENDS GETS TO BIG TO RESTORE ########
if [ $TYPE = "ET" -a $MODEL != "et10000" -a $MODEL != "et8000" ] ; then
	if [ $MEGABYTES -gt 128 ] ; then
    echo -n $RED
	$SHOW "message28" 2>&1 | tee -a $LOGFILE #Image too big
	echo $WHITE
	elif [ $MEGABYTES -gt 110 ] ; then
	echo -n $YELLOW
	$SHOW "message29" 2>&1 | tee -a $LOGFILE #Image between 111 and 128MB could cause problems
	echo $WHITE
	fi
fi

{
$SHOW "message03" ; echo -n "$ESTMINUTES.$ESTSECONDS "  ; $SHOW "message25"	# minutes 
echo $LINE
} 2>&1 | tee -a $LOGFILE


#exit 0  #USE FOR DEBUGGING/TESTING ###########################################


##################### PREPARING THE BUILDING ENVIRONMENT ######################
echo "*** FIRST SOME HOUSEKEEPING ***" >> $LOGFILE
rm -rf "$WORKDIR"		# GETTING RID OF THE OLD REMAINS IF ANY
echo "Remove directory   = $WORKDIR" >> $LOGFILE
mkdir -p "$WORKDIR"		# MAKING THE WORKING FOLDER WHERE EVERYTHING HAPPENS
echo "Recreate directory = $WORKDIR" >> $LOGFILE
mkdir -p /tmp/bi/root # this is where the complete content will be available
echo "Create directory   = /tmp/bi/root" >> $LOGFILE
sync
mount --bind / /tmp/bi/root # the complete root at /tmp/bi/root


####################### START THE REAL BACK-UP PROCESS ########################
#------------------------------------------------------------------------------
############################# MAKING UBINIZE.CFG ##############################
echo \[ubifs\] > "$WORKDIR/ubinize.cfg"
echo mode=ubi >> "$WORKDIR/ubinize.cfg"
echo image="$WORKDIR/root.ubi" >> "$WORKDIR/ubinize.cfg"
echo vol_id=0 >> "$WORKDIR/ubinize.cfg"
echo vol_type=dynamic >> "$WORKDIR/ubinize.cfg"
echo vol_name=rootfs >> "$WORKDIR/ubinize.cfg"
echo vol_flags=autoresize >> "$WORKDIR/ubinize.cfg"
echo $LINE >> $LOGFILE
echo "UBINIZE.CFG CREATED WITH THE CONTENT:"  >> $LOGFILE
cat "$WORKDIR/ubinize.cfg"  >> $LOGFILE
touch "$WORKDIR/root.ubi"
chmod 644 "$WORKDIR/root.ubi"
echo "--------------------------" >> $LOGFILE

#############################  MAKING ROOT.UBI(FS) ############################
$SHOW "message06a" 2>&1 | tee -a $LOGFILE		#Create: root.ubifs
$MKFS -r /tmp/bi/root -o "$WORKDIR/root.ubi" $MKUBIFS_ARGS
if [ -f "$WORKDIR/root.ubi" ] ; then
	echo -n "ROOT.UBI MADE  :" >> $LOGFILE
	ls -e1 "$WORKDIR/root.ubi" | sed 's/-r.*   1//' >>$LOGFILE
	UBISIZE=`cat "$WORKDIR/root.ubi" | wc -c`
	if [ "$UBISIZE" -eq 0 ] ; then 
		echo "Probably you are trying to make the back-up in flash memory" 2>&1 | tee -a $LOGFILE
		big_fail
	fi
else 
	echo "$WORKDIR/root.ubi NOT FOUND"  >> $LOGFILE
	big_fail
fi

echo $LINE >> $LOGFILE
echo "Start UBINIZING" >> $LOGFILE
$UBINIZE -o "$WORKDIR/root.ubifs" $UBINIZE_ARGS "$WORKDIR/ubinize.cfg" >/dev/null
chmod 644 "$WORKDIR/root.ubifs"
if [ -f "$WORKDIR/root.ubifs" ] ; then
	echo -n "ROOT.UBIFS MADE:" >> $LOGFILE
	ls -e1 "$WORKDIR/root.ubifs" | sed 's/-r.*   1//' >> $LOGFILE
else 
	echo "$WORKDIR/root.ubifs NOT FOUND"  >> $LOGFILE
	big_fail
fi

############################## MAKING KERNELDUMP ##############################
echo $LINE >> $LOGFILE
$SHOW "message07" 2>&1 | tee -a $LOGFILE			# Create: kerneldump
if [ $MODEL = "solo2" ] || [ $MODEL = "duo2" ] || [ $MODEL = "xpeedlx" ] || [ $MODEL = "xpeedlx3" ]; then
	$NANDDUMP /dev/mtd2 -q > "$WORKDIR/vmlinux.gz"
else 
	$NANDDUMP /dev/mtd1 -q > "$WORKDIR/vmlinux.gz"
fi
if [ -f "$WORKDIR/vmlinux.gz" ] ; then
	echo -n "VMLINUX.GZ MADE:" >> $LOGFILE
	ls -e1 "$WORKDIR/vmlinux.gz" | sed 's/-r.*   1//' >> $LOGFILE
else 
	echo "$WORKDIR/vmlinux.gz NOT FOUND"  >> $LOGFILE
	big_fail
fi
echo "--------------------------" >> $LOGFILE

############################ ASSEMBLING THE IMAGE #############################
#------------------------------------------------------------------------------
#################### HANDLING THE ET and XP1000[S] SERIES   ###################
if [ $TYPE = "ET" -o $TYPE = "XP" ] ; then
	make_folders
	mkdir -p "$EXTRA"
	echo "Created directory  = $EXTRA" >> $LOGFILE
	mv "$WORKDIR/root.ubifs" "$MAINDEST/rootfs.bin" 
	mv "$WORKDIR/vmlinux.gz" "$MAINDEST/kernel.bin"
	echo "rename this file to 'force' to force an update without confirmation" > "$MAINDEST/noforce"; 
	image_version > "$MAINDEST/imageversion" 
	cp -r "$MAINDEST" "$EXTRA" 	#copy the made back-up to images
	if [ -f "$MAINDEST/rootfs.bin" -a -f "$MAINDEST/kernel.bin" -a -f "$MAINDEST/imageversion" -a -f "$MAINDEST/noforce" ] ; then
		backup_made
		if [ $MODEL = "et9x00" -o $MODEL = "et6500" ] ; then 
			$SHOW "message12" 			# directions for a ET9x00/ET6500 series
		elif [ $MODEL = "et5x00" -o $MODEL = "et6000" -o $TYPE = "XP"  ] ; then 
			$SHOW "message13" 			# directions for a ET5X00/ET6000/XP1000 series
		else 
			$SHOW "message14" 			# Please check te manual of the receiver on how to restore the image.
		fi
	else
		big_fail
	fi
fi
#################### END OF THE ET AND XP1000 SERIES PART #####################
 
########################### HANDLING THE VU+ SERIES ###########################
if [ $TYPE = "VU" ] ; then
	make_folders
	mkdir -p "$EXTRA/$MODEL"
	echo "Created directory  = $EXTRA/$MODEL" >> $LOGFILE
	if [ $MODEL = "solo2" ] || [ $MODEL = "duo2" ]; then
		mv "$WORKDIR/root.ubifs" "$MAINDEST/root_cfe_auto.bin"
	else
		mv "$WORKDIR/root.ubifs" "$MAINDEST/root_cfe_auto.jffs2"
	fi
	mv "$WORKDIR/vmlinux.gz" "$MAINDEST/kernel_cfe_auto.bin"
	if [ $MODEL != "solo" -a $MODEL != "duo" ]; then
		touch "$MAINDEST/reboot.update"
		chmod 644 "$MAINDEST/reboot.update"
	fi
	image_version > "$MAINDEST/imageversion" 
	cp -r "$MAINDEST" "$EXTRA" 						#copy the made back-up to images
	if [ -f "$MAINDEST/root_cfe_auto"* -a -f "$MAINDEST/kernel_cfe_auto.bin" ] ; then
		backup_made
		$SHOW "message12" 			# directions for restoring the image for a vu+
	else
		big_fail
	fi
fi
######################### END OF THE VU+ SERIES PART ##########################

#################### CHECKING FOR AN EXTRA BACKUP STORAGE #####################
if  [ $HARDDISK = 1 ]; then						# looking for a valid usb-stick
	for candidate in /media/sd* /media/mmc* /media/usb* /media/*
	do
		if [ -f "${candidate}/"*[Bb][Aa][Cc][Kk][Uu][Pp][Ss][Tt][Ii][Cc][Kk]* ]
		then
		TARGET="${candidate}"
		fi    
	done
	if [ "$TARGET" != "XX" ] ; then
		echo $GREEN
		$SHOW "message17" 2>&1 | tee -a $LOGFILE 	# Valid USB-flashdrive detected, making an extra copy
		echo $LINE
		TOTALSIZE="$(df -h "$TARGET" | tail -n 1 | awk {'print $2'})"
		FREESIZE="$(df -h "$TARGET" | tail -n 1 | awk {'print $4'})"
		{
		$SHOW "message09" ; echo -n "$TARGET ($TOTALSIZE, " ; $SHOW "message16" ; echo "$FREESIZE)"
		} 2>&1 | tee -a $LOGFILE
		if [ $TYPE = "ET" ] ; then				# ET detected
			rm -rf "$TARGET/$MODEL"		
			mkdir -p "$TARGET/$MODEL"
			cp -r "$MAINDEST" "$TARGET"
			echo $LINE >> $LOGFILE
			echo "MADE AN EXTRA COPY IN: $TARGET" >> $LOGFILE
			df -h "$TARGET"  >> $LOGFILE
		elif [ $TYPE = "XP" ] ; then				# XP detected
			rm -rf "$TARGET/$MODEL"	
			mkdir -p "$TARGET/$MODEL"
			cp -r "$MAINDEST" "$TARGET"
			echo $LINE >> $LOGFILE
			echo "MADE AN EXTRA COPY IN: $TARGET" >> $LOGFILE
			df -h "$TARGET"  >> $LOGFILE
		elif [ $TYPE = "VU" ] ; then			# VU+ detected
			rm -rf "$TARGET/vuplus/$MODEL"
			mkdir -p "$TARGET/vuplus/$MODEL"
			cp -r "$MAINDEST" "$TARGET/vuplus/"
			echo $LINE >> $LOGFILE
			echo "MADE AN EXTRA COPY IN: $TARGET" >> $LOGFILE
			df -h "$TARGET"  >> $LOGFILE
		else 
			echo "NO additional USB-stick found to copy an extra backup" >> $LOGFILE
		fi
    sync
	$SHOW "message19" 2>&1 | tee -a $LOGFILE	# Backup finished and copied to your USB-flashdrive
	fi
fi
######################### END OF EXTRA BACKUP STORAGE #########################


################## CLEANING UP AND REPORTING SOME STATISTICS ##################
clean_up
END=$(date +%s)
DIFF=$(( $END - $START ))
MINUTES=$(( $DIFF/60 ))
SECONDS=$(( $DIFF-(( 60*$MINUTES ))))
if [ $SECONDS -le  9 ] ; then 
	SECONDS="0$SECONDS"
fi
echo -n $YELLOW

############ TEST INSERT #####################

ROOTSIZE=`ls "$MAINDEST" -e1S | grep root | awk {'print $3'} ` 
KERNELSIZE=`ls "$MAINDEST" -e1S | grep kernel | awk {'print $3'} ` 
TOTALSIZE=$((($ROOTSIZE+$KERNELSIZE)/1024))
SPEED=$(( $TOTALSIZE/$DIFF ))
{
$SHOW "message24"  ; echo -n "$MINUTES.$SECONDS " ; $SHOW "message25"
} 2>&1 | tee -a $LOGFILE
echo $SPEED > /usr/lib/enigma2/python/Plugins/Extensions/BackupSuite-HDD/speed.txt
#####################################################

echo $LINE >> $LOGFILE
#echo "BACKUP FINISHED IN $MINUTES.$SECONDS MINUTES" >> $LOGFILE
{
$SHOW "message26" ; echo -n "$SPEED" ; $SHOW "message27"
} 2>&1 | tee -a $LOGFILE

#echo "Back up done with $SPEED KB per second"  >> $LOGFILE
echo -n $WHITE
cp $LOGFILE "$MAINDEST"
if [ $TYPE = "VU" ] ; then
	cp $LOGFILE "$EXTRA/$MODEL"
else
	cp $LOGFILE "$EXTRA"
fi
exit 
#-----------------------------------------------------------------------------
