#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2008-2014                                                 #
#                                                                              #
# contact: http://pkteam.pl                                                    #
#                                                                              #
################################################################################

box=`cat /etc/boxtype`

if [ $box != hypercube ] && [ $box != mips ]; then
. /var/config/time.conf
. /var/config/highSR.conf
. /var/config/swts.conf
. /var/config/wlan.conf
fi

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

upt=`uptime | awk '{print $3 " " $4}'`
echo "_(Uptime:)" $upt "\n"

proc=`df -h / | grep root | awk '{print $5}'`
size=`df -h / | grep root | awk '{print $2}'`
used=`df -h / | grep root | awk '{print $3}'`
available=`df -h / | grep root | awk '{print $4}'`
echo "_(System partition usage:)" $proc " _(Size:)" $size  "_(Used:)" $used  "_(Available:)" $available "\n"

if [ $box == ufs912 ] || [ $box == sf1028 ] && [ -e /var/config/flash ] ; then
    if [ $box == ufs912 ]; then
        MTD="5"
        PATH_DIR="/ExtraCache"
    elif [ $box == sf1028 ]; then
        MTD="3"
        PATH_DIR="/usr/lib/enigma2"
    fi

    proc=`df -h $PATH_DIR | grep mtdblock$MTD | awk '{print $5}'`
    size=`df -h $PATH_DIR | grep mtdblock$MTD | awk '{print $2}'`
    used=`df -h $PATH_DIR | grep mtdblock$MTD | awk '{print $3}'`
    available=`df -h $PATH_DIR | grep mtdblock$MTD | awk '{print $4}'`
    echo "_(Extended partition usage:)" $proc " _(Size:)" $size  "_(Used:)" $used  "_(Available:)" $available "\n"
fi

echo "_(Memory usage: )"
free1=`free | grep Mem | awk '{print $2 "  " $3 "  " $4}'`
free2=`free | grep Swap | awk '{print $2 "  " $3 "  " $4}'`
echo "        _(Total:)"  " _(Used:)"  " _(Free:)"
echo "Mem: $free1"
echo "Swap: $free2" "\n"

if [ $box != hypercube ] && [ $box != mips ]; then
    echo "SWTS: $swts"
    echo "HighSR: $highSR"
    echo "_(Standby Time:)" $czas
    ply=`cat /proc/stb/player/version`
    echo "Player: " $ply
    if [ $wlan == off ]; then
        echo "WLAN Support: Disable"
    else
        echo "WLAN Support: $wlan driver active"
    fi
fi

echo ""
 
exit 0

