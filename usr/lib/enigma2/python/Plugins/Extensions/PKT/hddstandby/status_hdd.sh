if [ -e /var/config/sdparm.on ]; then
  echo "Current hdd setting: use sdparm"
else
  echo "Current hdd setting: use hdparm"
fi 
