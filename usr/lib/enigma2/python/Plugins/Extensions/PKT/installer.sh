#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2008-2013                                                 #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

box=`cat /etc/boxtype`

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

detect_device()
{
 rm /var/etc/devices 2> /dev/null

 lista=`fdisk -l | grep '/dev/' | awk '{gsub("/"," "); print $2}' | awk '{gsub("dev",""); print $1}'`
 id=1

 for i in $lista; do
     echo "dev$id= $i" >> /var/etc/devices
     id=$(($id+1))
 done

 if ! [ -e /var/etc/devices ]; then
     echo "Disk no_disk" > /var/etc/devices
 fi
}

detect_image()
{
 rm /var/etc/images 2> /dev/null
 if [ $box == hypercube ]; then
    lista2=`ls /media/hdd | grep .tar.gz | awk '{gsub(".tar.gz",""); print $1}'`
 else
    lista2=`ls /hdd | grep .tar.gz | awk '{gsub(".tar.gz",""); print $1}'`
 fi
 id2=1

 for i in $lista2; do
     echo "image$id2= $i" >> /var/etc/images
     echo "image$id2= $i"
     id2=$(($id2+1))
 done

 if ! [ -e /var/etc/images ]; then
     echo "image no_image_found" > /var/etc/images
     echo "image no_image_found"
 fi
}

detect_uboot_backup()
{
 rm /var/etc/uboot 2> /dev/null

 lista3=`ls /hdd | grep .bin | grep uboot | awk '{gsub(".bin",""); print $1}'`
 id3=1

 for i in $lista3; do
     echo "image$id3= $i" >> /var/etc/uboot
     echo "image$id3= $i"
     id3=$(($id3+1))
 done

 if ! [ -e /var/etc/uboot ]; then
     echo "uboot no_uboot_backup_found" > /var/etc/uboot
     echo "uboot no_uboot_backup_found"
 fi
}

detect_softusb_image()
{
 rm /var/etc/softusbimage 2> /dev/null

 lista4=`ls /usb/softusb/images | awk '{print $1}'`
 id4=1

 for i in $lista4; do
     echo "image$id4= $i" >> /var/etc/softusbimage
     echo "image$id4= $i"
     id4=$(($id4+1))
 done

 if ! [ -e /var/etc/softusbimage ]; then
     echo "image no_softusb_image_found" > /var/etc/softusbimage
     echo "image no_softusb_image_found"
 fi
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'device')
    detect_device
    ;;
 'image')
    detect_image
    ;;
 'uboot')  
    detect_uboot_backup
    ;;
 'softusbimage')  
    detect_softusb_image
    ;;
 *)
    echo -e "\nUse: installer.sh device|image|uboot|softusbimage"
    ;;
esac

exit 0
