#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011                                                      #
#                                                                              #
# contact: http://pkteam.pl                                                    #
#                                                                              #
################################################################################

. /var/config/link
. /var/config/symlink
. /var/config/revision


#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

wget -P /tmp $ADRES/$VERSION/aktualizacja.tar.gz 2>/dev/null   
echo "_(Downloading new version)"
echo ""
if [ -e /tmp/aktualizacja.tar.gz ] ; then      
echo "_(Extracting new version)"
cd /      
gunzip -c /tmp/aktualizacja.tar.gz  | tar xf -      

rm /tmp/aktualizacja.tar.gz
   echo ""
   echo "_(Update successfull)"
   sync
   sleep 3
   echo ""
if [ -e $SYMLINK/reboot_e2 ] ; then 
   echo "_(In 5 sec E2 will be restarted)"
   rm $SYMLINK/reboot_e2
   sleep 5
   killall -9 enigma2
fi

if [ -e $SYMLINK/reboot_box ] ; then 
   echo "_(In 5 sec box will be restarted)"
   rm $SYMLINK/reboot_box
   sleep 5
   reboot -f
fi

else     
   echo "_(No archive on server or downloading error!)"
fi

sync

exit 0
