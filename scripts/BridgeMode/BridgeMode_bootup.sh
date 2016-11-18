#!/bin/sh

sleep 20

BRIDGEMODE_ENABLE=`dmcli simu getv Device.X_CISCO_COM_DeviceControl.LanManagementEntry.1.LanMode | grep value | cut -f3 -d : | cut -f2 -d" "`
if [ "$BRIDGEMODE_ENABLE" = "bridge-static" ]; then
	brctl delif brlan0 wlan0
	killall dnsmasq
	killall udhcpd
	killall CcspLMLite
fi
