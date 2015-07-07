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

clean_devs()
{
 rm /dev/ttyUSB0 2>/dev/null
 rm /dev/ttyUSB1 2>/dev/null
}

usbserial_pl2303()
{
 echo serial=pl2303 >/var/config/usbserial.conf
 sync
 echo "_(PL2303 activated)"
 echo "\n""_(Restart box to save changes!)"
} 

usbserial_ftdi()
{
 echo serial=ftdi >/var/config/usbserial.conf
 sync
 echo "_(FTDI activated)"
 echo "\n""_(Restart box to save changes!)"
}

usbserial_both()
{
 echo serial=both >/var/config/usbserial.conf
 sync
 echo "_(PL2303 & FTDI activated)"
 echo "\n""_(Restart box to save changes!)" 
}

usbserial_disable()
{
 echo serial=off >/var/config/usbserial.conf
 sync
 echo "_(PL2303 & FTDI disabled)"
 echo "\n""_(Restart box to save changes!)"
}

status()
{
 . /var/config/usbserial.conf

    if [ $serial == off ]; then
        echo "_(PL2303 & FTDI are not active)"
    elif [ $serial == pl2303 ]; then
        echo "_(PL2303 driver is active)"
    elif [ $serial == ftdi ]; then
        echo "_(FTDI driver is active)"
    elif [ $serial == both ]; then
        echo "_(PL2303 & FTDI drivers are active)"
    fi
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'pl2303')
    clean_devs
    usbserial_pl2303
    ;;
 'ftdi')
    clean_devs
    usbserial_ftdi
    ;;
 'both')
    clean_devs
    usbserial_both
    ;;
 'off')
    clean_devs
    usbserial_disable
    ;;
 'status')
    status
    ;;
 *)
    echo -e "\nUse: usbserial.sh pl2303|ftdi|both|off|status"
    ;;
esac

echo ""
exit 0
