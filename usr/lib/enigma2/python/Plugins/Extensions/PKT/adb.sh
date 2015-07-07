#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2012                                                      #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

box=`cat /etc/boxtype`

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

vfd_on()
{
 rm /var/etc/bska_lfd
 sync
 echo "_(VFD Panel Enable)\n_(Please restart Box)"
} 

vfd_off()
{
 touch /var/etc/bska_lfd
 sync
 echo "_(VFD Panel Disable)\n_(Please restart Box)"
}

tda_on()
{
 touch /var/etc/sci_tda
 sync
 echo "_(SCI1 TDA Enable)\n_(Please restart Box)"
} 

tda_off()
{
 rm /var/etc/sci_tda
 sync
 echo "_(SCI1 TDA Disable)\n_(Please restart Box)"
}

fan_off()
{
 rm /var/etc/bska_fan
 sync
 echo "_(Fan support disable)\n_(Please restart Box)"
} 

fan_on()
{
 touch /var/etc/bska_fan
 sync
 echo "_(Fan support enable)\n_(Please restart Box)"
}

pilot_on()
{
 touch /var/etc/pilot
 echo "_(In 15 sec box will be restarted)"
 sync
 sleep 15
 reboot -f
} 

pilot_off()
{
 rm /var/etc/pilot
 echo "_(In 5 sec box will be restarted)"
 sync
 sleep 5
 reboot -f
}


#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'vfd')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ] || [ $box == esi88 ];then
        vfd_on
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 'lfd')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ];then
        vfd_off
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 'pilot_on')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ];then
        pilot_on
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 'pilot_off')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ];then
        pilot_off
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 'fan_on')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ];then
        fan_on
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 'fan_off')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ];then
        fan_off
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 'tda_on')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ];then
        tda_on
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 'tda_off')
    if [ $box == bska ] || [ $box == bsla ] || [ $box == bxzb ] || [ $box == bzzb ];then
        tda_off
    else
        echo "_(This option is not available on this STB)"
    fi
    ;;
 *)
    echo -e "\nUse: adb.sh bsla|bska|vfd|lfd"
    ;;
esac

echo ""
exit 0
