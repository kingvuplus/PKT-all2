#!/bin/sh
################################################################################
#                                                                              #
# Polish Koders Team 2011                                                      #
#                                                                              #
# contact: http://pkteam.pl                                                   #
#                                                                              #
################################################################################

. /var/config/symlink
. /var/config/link
. /var/config/revision

#-------------------------------------------------------------------------------
#script section
#-------------------------------------------------------------------------------

wget $ADRES/$VERSION/wersjas -q -O /tmp/wersjas 2>/dev/null  
wget $ADRES/$VERSION/conowego -q -O /tmp/conowego 2>/dev/null

if [ -e /tmp/wersjas ]; then

    . /tmp/wersjas
    . /tmp/conowego
    . $SYMLINK/wersjal

    if [ $wersjal = $wersjas ]; then
        echo "_(You are using valid E2 mod PKT version -)" $wersjal
    else
        echo "_(You are using E2 mod PKT version)" $wersjal "\n"
        echo "_(Update E2 mod PKT to version)" $wersjas "\n\n\n"
        echo "_(What's new in)" "$wersjas :" "\n"
        echo "$co_nowego" "\n\n"
        rm -r /tmp/wersjas
        rm -r /tmp/conowego
    fi

else
   echo "\n" "_(No available updates on server or downloading error !)"
fi