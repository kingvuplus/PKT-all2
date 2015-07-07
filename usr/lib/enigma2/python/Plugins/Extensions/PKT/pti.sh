#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011                                                      #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

box=`cat /etc/boxtype`

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

pti_on()
{
 echo cam_routing=on >/var/config/pti.conf
 sync
 echo "_(Cam Routing activated)" "\n"
 echo "_(Restart box to save changes!)" "\n"
 echo "_(NOTE: When this option is Enable some Polish HD channels don't work)"
} 

pti_off()
{
 echo cam_routing=off >/var/config/pti.conf
 sync
 echo "_(Cam Routing deactivated)" "\n"
 echo "_(Restart box to save changes!)" 
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'on')
    if [ $box == ufs910 ]; then
        pti_on
        echo "test"
    else
        echo "_(Cam Routing work only with UFS910)"
    fi
    ;;
 'off')
    if [ $box == ufs910 ]; then
        pti_off
    else
        echo "_(Cam Routing work only with UFS910)"
    fi
    ;;
 *)
    echo -e "\nUse: pti.sh on|off"
    ;;
esac

echo ""
exit 0
