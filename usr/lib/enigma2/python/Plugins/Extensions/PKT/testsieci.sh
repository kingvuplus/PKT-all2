#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2008-2014                                                 #
#                                                                              #
# contact: http://pkteam.pl                                                    #
#                                                                              #
################################################################################

box=`cat /etc/boxtype`

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------
eth_list="wlan0 ra0 eth0"
for i in $eth_list
do
    wlan_active=`ifconfig $i | grep inet` 2>/dev/null
    if [ -n "$wlan_active" ]; then
        interface=$i
    fi
done

mac=`ifconfig $interface | grep HWaddr | awk '{print $5}'` 2>/dev/null
if [ $interface == eth0 ]; then
    echo "_(LAN MAC)" ": $mac"
else
    echo "_(WIFI MAC)" ": $mac"
fi

adres=`ifconfig $interface | grep addr: | awk '{gsub(/:/," "); print $3}' | head -n 1` 2>/dev/null
echo "_(IP address:) $adres"

maska=`ifconfig $interface | grep addr: | awk '{gsub(/:/," "); print $7}' | head -n 1` 2>/dev/null
echo "_(Mask:) $maska"

brama=`route | grep default | awk '{gsub(/:/," "); print $2}'`
echo "_(Gate:) $brama"

dns=`cat /etc/resolv.conf | grep nameserver | awk '{gsub(/:/," "); print "DNS: "$2}'`
echo "$dns"

status1="Error _(Gate:) $brama _(doesn't reply for PING!)"
if [ `ping -c 1 -w 1 $brama | grep "1 packets received" | awk '{print $1}'` ] ; then status1="_(Gate: replies for PING)" ; fi

dns_test=`cat /etc/resolv.conf | grep nameserver | awk '{gsub(/:/," "); print $2}' | tail -1`
status2="_(Error) $dns_test _(doesn't resolve names!)"
if [ `nslookup 'www.wp.pl' "$dns_test" | grep "Address" | grep "www.wp.pl" | awk '{print $3}'` ] ; then status2="_(Name server: resolves names properly)" ; fi


echo "\n"$status1
echo $status2 "\n"


echo "_(Server PKT connection test)"
ping -c 1 -w 2 -W 2 pkteam.pl

exit 0