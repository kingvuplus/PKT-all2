#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011-2013                                                 #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################
#rev2

. /var/config/ipkg.conf

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

ipkg_update_on()
{
 echo ipkg_update=on >/var/config/ipkg.conf
 sync
} 

ipkg_update_off()
{
 echo ipkg_update=off >/var/config/ipkg.conf
 sync
}

ipkg_online_update()
{
 if [ $ipkg_update == on ]; then
     sleep 60
     opkg update &
 fi
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'on')
    ipkg_update_on
    ;;
 'off')
    ipkg_update_off
    ;;
 'update')
    ipkg_online_update
    ;;
 *)
    echo -e "\nUse: ipkg.sh on|off|update"
    ;;
esac

echo ""
exit 0
