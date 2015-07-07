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
make_swap()
{
  if [ ! -e /var/config/flash ]; then
    PATCH="/swap"
  else
    PATCH="/hdd/swap"
  fi

  if [ ! -e $PATCH/swapfile ]; then
    if [ $box != gm990 ] && [ $box != hypercube ] && [ ! -e /var/etc/sf1008+ ] && [ ! -e /var/etc/ip55 ] && [ ! -e /var/etc/ip91 ]; then
        echo "SWAP init.." > /dev/vfd
    fi
    echo "SWAP init.." "\n"
    mkdir $PATCH
    if [ $box == mips ]; then
      dd if=/dev/zero of=$PATCH/swapfile bs=8192 count=32768
    else
      dd if=/dev/zero of=$PATCH/swapfile bs=8192 count=8192
    fi
    mkswap $PATCH/swapfile
    chown root:root $PATCH/swapfile
    chmod 0600 $PATCH/swapfile
    swapon $PATCH/swapfile
  else
    if [ $box != gm990 ] && [ $box != hypercube ] && [ ! -e /var/etc/sf1008+ ] && [ ! -e /var/etc/ip55 ] && [ ! -e /var/etc/ip91 ]; then
	echo "SWAP FILE ON" > /dev/vfd
    fi
    echo "SWAP FILE ON"
    mkswap $PATCH/swapfile
    chown root:root $PATCH/swapfile
    chmod 0600 $PATCH/swapfile
    swapon $PATCH/swapfile
    sleep 2
  fi
}

start_swap()
{
 . /var/config/swap.conf
 if [ $swap == on ]; then
   echo "_(Detecting SWAP partition, wait...)"
   if [ $box == mips ]; then
      id_swap=`fdisk -l | grep 'Linux Swap' | awk '{print $6}' | head -n 1`
   else
      id_swap=`fdisk -l | grep 'Linux swap' | awk '{print $5}' | head -n 1`
   fi
   echo ""

   if [ $id_swap == "82" ] 2>/dev/null; then
	if [ $box == mips ]; then
	  swap_dev=`fdisk -l | grep 'Linux Swap' | awk '{print $1}' | head -n 1`
	else
	  swap_dev=`fdisk -l | grep 'Linux swap' | awk '{print $1}' | head -n 1`
	fi
       echo "_(SWAP detected on )" $swap_dev "\n"
       mkswap $swap_dev
       chown root:root $swap_dev
       chmod 0600 $swap_dev
       swapon $swap_dev
       echo ""
       if [ $box != gm990 ] && [ $box != hypercube ] && [ ! -e /var/etc/sf1008+ ] && [ ! -e /var/etc/ip55 ] && [ ! -e /var/etc/ip91 ]; then
            echo "SWAP PART ON" > /dev/vfd
       fi
       sleep 1
       echo "_(SWAP partition activated)" "\n"
   else
       echo "_(SWAP is missing or wrong partition type)" "\n"
       echo "_(SWAP file emulation activated)" "\n"
       echo "_(Wait...)"
       if [ ! -e /var/config/flash ]; then
            make_swap
            echo ""
            echo "_(SWAP mounted)" "\n"
       else       
            test=`mount | grep hdd | awk '{print $5}'`
            if [ $test != ntfs ] && [ -n "$test" ]; then
                make_swap
                echo ""
                echo "_(SWAP mounted)" "\n"
              else
                echo ""
                echo "_(error: /hdd must be mounted)" "\n"
            fi
       fi
   fi
 fi
}

stop_swap()
{
 . /var/config/swap.conf
 if [ $swap == on ]; then
    echo swap=off >/var/config/swap.conf
    sync
    
    if [ ! -e /var/config/flash ]; then
        PATCH="/swap"
    else
        PATCH="/hdd/swap"
    fi

    if [ -e $PATCH/swapfile ]; then
        swapoff $PATCH/swapfile
        rm $PATCH/swapfile
        rmdir $PATCH/
    else
	if [ $box == mips ]; then
	    id_swap=`fdisk -l | grep 'Linux Swap' | awk '{print $1}' | head -n 1`
	else
	    id_swap=`fdisk -l | grep 'Linux swap' | awk '{print $1}' | head -n 1`
	fi
        swapoff $id_swap
    fi
    
    echo "_(Swap was deactivated and will not be loading during next start.)"
    sync
 else
    echo "_(SWAP is not active)" "\n"
 fi
}

status_swap()
{
 . /var/config/swap.conf
 free_swap1=`free | grep Swap | awk '{print $3}'`
 free_swap2=`free | grep Swap | awk '{print $4}'`
 free_swap3=`free | grep Swap | awk '{print $2}'`

 if [ $swap == on ]; then
    if [ $box == mips ]; then
	id_swap=`fdisk -l | grep 'Linux Swap' | awk '{print $6}' | head -n 1` 
    else
	id_swap=`fdisk -l | grep 'Linux swap' | awk '{print $5}' | head -n 1`
    fi

    if [ $id_swap == "82" ] 2>/dev/null; then 
        echo "SWAP Type: Linux Partition"
    else
        echo "SWAP Type: File Emulated"
    fi

    echo ""
    echo "_(Swap usage:)"
    echo ""
    echo "_(Used: )" $free_swap1 " kB"
    echo "_(Free: )" $free_swap2 " kB"
    echo "_(Sum.: )" $free_swap3 " kB"
    echo ""

 else
    echo "_(SWAP is not active)" "\n"
    echo "_(If you want to use SWAP partition activate it)" "\n"
    echo "_(USB STICK or USB HARDDISK is REQUIRED)" "\n"
    echo "_(Supported Filesystem: ext2, ext3, vfat, LinuxSwap)" "\n"    
 fi
}

enable_swap()
{
 . /var/config/swap.conf
   if [ $swap == on ]; then
        echo "SWAP is currently switched on" "\n"
        status_swap
   else 
        echo swap=on >/var/config/swap.conf
        sync
        start_swap
   fi 
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'start')
    enable_swap
    ;;
 'stop')
    stop_swap
    ;;
 'run')
    start_swap
    ;;
 'status')
    status_swap
    ;;
 *)
    echo -e "\nUse: swapstarter.sh start|stop|run|status"
    ;;
esac

exit
