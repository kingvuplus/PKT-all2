#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2008-2013                                                 #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

cable()
{
 echo UnionTunerType=c >/var/config/tuner.conf
 sync
 echo "_(DVB-C tuner activated)" "\n"
 echo "_(Restart box to save changes!)" "\n"
} 

terrestrial()
{
 echo UnionTunerType=t >/var/config/tuner.conf
 sync
 echo "_(DVB-T tuner activated)" "\n"
 echo "_(Restart box to save changes!)" 
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'dvbc')
    cable
    ;;
 'dvbt')
    terrestrial
    ;;
 *)
    echo -e "\nUse: pti.sh dvbc|dvbt"
    ;;
esac

echo ""
exit 0
