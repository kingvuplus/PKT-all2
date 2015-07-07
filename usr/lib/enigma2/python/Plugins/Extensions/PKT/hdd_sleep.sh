#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011                                                      #
#                                                                              #
# contact: http://pkteam/                                                      #
#                                                                              #
################################################################################

echo "_(syncing disk..)"
sync
sleep 2

echo "\n""_(activating standby command..)"

if [ -e /var/config/sdparm.on ]; then
  sdparm -C stop /dev/sda 2>/dev/null
  sdparm -C stop /dev/sdb 2>/dev/null
  sdparm -C stop /dev/sdc 2>/dev/null
else
  hdparm -y /dev/sda 2>/dev/null
  hdparm -y /dev/sdb 2>/dev/null
  hdparm -y /dev/sdc 2>/dev/null
  hdparm -y /dev/sdd 2>/dev/null
fi
sleep 3

echo "\n""_(HDD is sleeping)" 
echo ""

exit 0

cat /proc/partitions | grep 'sda$' | cut -ds -f2
