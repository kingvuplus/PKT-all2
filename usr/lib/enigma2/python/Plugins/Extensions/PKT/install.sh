#!/bin/sh
cd /
echo -------------------------------------------------------------------------
echo $1
echo -------------------------------------------------------------------------
case $1 in
  "ls")
      ls -alh /tmp/*.ipk
    echo -------------------------------------------------------------------------
      ls -alh /tmp/*.bz2
    echo -------------------------------------------------------------------------
      ls -alh /tmp/*.gz
  ;;
  "lsbz2")
    ls -alh /tmp/*.bz2
  ;;
  "lsgz")
    ls -alh /tmp/*.gz
  ;;
  "lsipk")
    ls -alh /tmp/*.ipk
  ;;
  "df")
    df -h /tmp
  ;;
  "rmbz2")
    rm /tmp/*.bz2
  ;;
  "rmgz")
    rm /tmp/*.gz
  ;;
  "rmipk")
    rm /tmp/*.ipk
  ;;
  "contentbz2")
    tar -tvjf /tmp/*.tar.bz2
  ;;
  "contentgz")
    tar -tvzf /tmp/*.tar.gz
  ;;
  "installipk")
    opkg install -force-overwrite -force-depends /tmp/*.ipk
    rm /tmp/*.ipk
  ;;
  "installbz2")
    tar -xvjf /tmp/*.tar.bz2
  ;;
  "installgz")
    tar -xvzf /tmp/*.tar.gz
  ;;
  *)
    echo "unsupported command"
  ;;
esac
echo -------------------------------------------------------------------------
exit 0
