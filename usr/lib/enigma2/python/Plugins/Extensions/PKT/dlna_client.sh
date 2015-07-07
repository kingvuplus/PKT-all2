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

djmount_check()
{
 if ! [ -x /etc/init.d/djmount ]; then
    echo "_(DLNA client is not installed.)\n"
    exit 0
 fi
}

dlna_client_on()
{
 djmount_check
 rm -R /dev/fuse
 mknod /dev/fuse -m 0666 c 10 229
 /etc/init.d/djmount start
 touch /var/config/djmount_active
 sync
 echo "_(DLNA client activated.)\n\n_(Check your DLNA devices in destination /media/upnp/)\n"
} 

dlna_client_off()
{
 djmount_check
 /etc/init.d/djmount stop
 rm /var/config/djmount_active
 sync
 echo "_(DLNA client disabled.)\n\n_(Devices has been removed from /media/upnp/ destination.)\n"
} 

#-------------------------------------------------------------------------------
#use section
#-------------------------------------------------------------------------------

case "$1" in
 'start')
    dlna_client_on 2>/dev/null
    ;;
 'stop')
    dlna_client_off 2>/dev/null
    ;;
 *)
    echo -e "\nUse: dlna_client.sh start|stop"
    ;;
esac

echo ""
exit 0
