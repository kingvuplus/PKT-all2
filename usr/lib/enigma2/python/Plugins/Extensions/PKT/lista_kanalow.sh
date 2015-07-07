#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011                                                      #
#                                                                              #
# contact: http://pkteam.pl                                                    #
#                                                                              #
################################################################################

GDZIE=/etc

. /var/config/link

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

wget -P /tmp ${ADRES%.pl*}".pl/channel_lists_e2/"$1 2>/dev/null   

if [ -e /tmp/$1 ] ; then      

    echo "_(Deleting old channel list)" "\n"
    rm $GDZIE/enigma2/userbouquet* 2>/dev/null
    rm $GDZIE/enigma2/bouquets* 2>/dev/null
    rm $GDZIE/enigma2/lamedb 2>/dev/null
    rm $GDZIE/enigma2/satellites.xml 2>/dev/null
    rm $GDZIE/enigma2/whitelist 2>/dev/null
    rm $GDZIE/enigma2/blacklist 2>/dev/null
    rm /etc/tuxbox/satellites.xml 2>/dev/null
    
    sleep 3

    echo "_(Channel list update)" "\n"
    cd /
    tar -xvzf /tmp/$1 -C $GDZIE >/dev/null
    
    sleep 2
    
    cp $GDZIE/enigma2/satellites.xml /etc/tuxbox/satellites.xml
    rm /tmp/$1

    sleep 1
    wget -q http://127.0.0.1/web/servicelistreload?mode=0 -O /dev/null
    wget -q http://127.0.0.1/web/subservices -O /dev/null

    sleep 2
    echo "_(Successfull update)" "\n"

#    echo "_(In 5 sek E2 will be restarted)"
#    sync

#    sleep 5
#    killall -9 enigma2

else     
    echo "_(No archive on server or downloading error!)"
fi

exit 0
