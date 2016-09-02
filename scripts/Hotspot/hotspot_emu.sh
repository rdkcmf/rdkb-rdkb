#!/bin/sh

sleep 30

HOTSPOT_ENABLE=`dmcli simu getv Device.DeviceInfo.X_COMCAST_COM_xfinitywifiEnable | grep value | cut -f3 -d : | cut -f2 -d" "`
if [ "$HOTSPOT_ENABLE" = "true" ]; then
echo "CCSP-HOTSPOT"
/lib/rdk/handle_emu_gre.sh create
echo "CCSP-HOTSPOT IS SUCCESSFULLY RUNNING"
fi


