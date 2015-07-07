#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011                                                      #
#                                                                              #
# contact: http://pkteam.pl/                                                   #
#                                                                              #
################################################################################

box=`cat /etc/boxtype`

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

downmix_on()
{
 ln -s /usr/local/var/audio_dts.elf /boot/audio_dts.elf
 sync
 echo "_(DTS Downmix Enable)\n_(Please restart Box)"
} 

downmix_off()
{
 rm /boot/audio_dts.elf
 sync
 echo "_(DTS Downmix Disable)\n_(Please restart Box)"
}

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'on')
    if [ $box == ufs910 ];then
        downmix_on
    else
        echo "_(DTS Downmix not available in this STB)"
    fi
    ;;
 'off')
    if [ $box == ufs910 ];then
        downmix_off
    else
        echo "_(DTS Downmix not available in this STB)"
    fi
    ;;
 *)
    echo -e "\nUse: DTS.sh on|off"
    ;;
esac

echo ""
exit 0
