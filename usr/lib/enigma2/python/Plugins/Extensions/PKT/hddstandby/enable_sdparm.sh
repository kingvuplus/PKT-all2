case $1 in
  0) ln -s /bin/busybox /sbin/hdparm
     rm -f /var/config/sdparm.on
     echo "_(E2 configured to use hdparm)";;
  1) 
     rm -f /sbin/hdparm
     touch /var/config/sdparm.on
     echo "_(E2 configured to use sdparm)";;
esac
