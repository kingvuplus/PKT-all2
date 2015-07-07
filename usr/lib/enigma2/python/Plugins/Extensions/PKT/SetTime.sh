#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2008-2014                                                 #
#                                                                              #
# contact: http://pkteam.pl                                                    #
#                                                                              #
################################################################################

server=`cat /etc/enigma2/settings | grep SyncTime.server | awk '{gsub(/=/," "); print $2}'`

echo "Synchronizing NTP time..."
ntpd -n -N -q -p $server
echo "Done"
