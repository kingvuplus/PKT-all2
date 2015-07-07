#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2013                                                      #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

cleanOn()
{
 touch /var/config/clean.mem
 echo "_(Warning!\n\nThis function can cause unstable STB operation.\n)"
 echo "_(Problems detected: unexplained situations that may lead to losing the signal or blank timer recordings.\n\n)"
 echo "_(Memory will be automatically cleaned up after switch to standby mode.\n\nPress any key)"
}

cleanOff()
{
 rm /var/config/clean.mem
 echo "_(Memory cleaning in standby mode is disabled.\n\nPress any key)"
}
 
#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'on')
    cleanOn
    ;;
 'off')
    cleanOff
    ;;
 *)
    echo -e "\nUse: cleanMem.sh on|off"
    ;;
esac

exit  
