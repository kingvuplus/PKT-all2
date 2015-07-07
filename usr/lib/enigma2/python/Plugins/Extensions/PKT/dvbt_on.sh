#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011                                                      #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

. /var/config/symlink

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

echo dvbt=on >/etc/dvbt
sync
echo "_(DVB-T would be activated during next start)"
sleep 5
sync
echo "_(Restart STB manualy from Main Menu)"
exit 0
