#!/bin/sh
################################################################################
#                                                                              #
# Polish Kathi Team 2011                                                       #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

swts_on()
{
 echo swts=on >/var/config/swts.conf
 sync
 echo "_(SWTS activated)"
 echo "\n" "_(Restart box to save changes!)"
} 

swts_off()
{
 echo swts=off >/var/config/swts.conf
 sync
 echo "_(SWTS deactivated)"
 echo "\n" "_(Restart box to save changes!)"
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'on')
    swts_on
    ;;
 'off')
    swts_off
    ;;
 *)
    echo -e "\nUse: swts.sh on|off"
    ;;
esac

echo ""
exit 0
