#
# ============================================================================
# COMCAST C O N F I D E N T I A L AND PROPRIETARY
# ============================================================================
# This file and its contents are the intellectual property of Comcast.  It may
# not be used, copied, distributed or otherwise  disclosed in whole or in part
# without the express written permission of Comcast.
# ============================================================================
# Copyright (c) 2015 Comcast. All rights reserved.
# ============================================================================
#



#!/bin/sh


Restart_Hostapd () {


        ifconfig mon.wlan0 down
        ps | grep host | grep -v grep | awk '{print $1}' | xargs kill -9
        ifconfig wlan0 down
        ifconfig wlan0_0 down

        ifconfig wlan0 up
        hostapd -B /etc/hostapd.conf
        ifconfig mon.wlan0 up
        ifconfig wlan0_0 up

        ps | grep host | grep -v grep | awk '{print $1}' | xargs kill -9
        ifconfig wlan0 up
        hostapd -B /etc/hostapd.conf
        ifconfig mon.wlan0 up
        ifconfig wlan0_0 up
}

Hostapd_Restart () {
	
        ps | grep host | grep -v grep | awk '{print $1}' | xargs kill -9
        ifconfig wlan0 up
        hostapd -B /etc/hostapd.conf
        ifconfig mon.wlan0 up
        ifconfig wlan0_0 up

}

HOTSPOT_ENABLE=`dmcli simu getv Device.DeviceInfo.X_COMCAST_COM_xfinitywifiEnable | grep value | cut -f3 -d : | cut -f2 -d" "`
echo "HOTSPOT_ENABLE = $HOTSPOT_ENABLE"
if [ "$HOTSPOT_ENABLE" = "true" ]; then
echo "CCSP-HOTSPOT-RESTART"
Restart_Hostapd

################# Checking the Hostapd Status Again(due to wlan0_0 failure status) #########################

HOTSPOT_RESTART=`ifconfig wlan0_0 | grep RUNNING | tr -s ' ' | cut -d " " -f4`
while [ "$HOTSPOT_RESTART" != "RUNNING" ]
do
Hostapd_Restart
HOTSPOT_RESTART=`ifconfig wlan0_0 | grep RUNNING | tr -s ' ' | cut -d " " -f4`
done

/lib/rdk/handle_emu_gre.sh create
echo "CCSP-HOTSPOT IS SUCCESSFULLY RUNNING"
fi

