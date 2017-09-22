#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2016 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################



INTERFACE_5G=`cat /etc/hostapd_5G.conf | grep -w interface | head -1 | cut -d '=' -f2`

Restart_Hostapd () {

	ps -eaf | grep hostapd_xfinity_5G | grep -v grep | awk '{print $2}' | xargs kill -9
	rmmod rtl8812au
	sleep 1
	insmod /lib/modules/3.14.4-yocto-standard/kernel/drivers/net/wireless/rtl8812au/rtl8812au.ko
	sleep 2 
        ifconfig $INTERFACE_5G down
        sleep 3
        ifconfig $INTERFACE_5G up
        hostapd -B /etc/hostapd_xfinity_5G.conf 
	sleep 2
        hostapd -B /etc/hostapd_5G.conf 

}

HOTSPOT_ENABLE=`dmcli simu getv Device.DeviceInfo.X_COMCAST_COM_xfinitywifiEnable | grep value | cut -f3 -d : | cut -f2 -d" "`

echo "HOTSPOT_ENABLE_5G = $HOTSPOT_ENABLE"


if [ "$HOTSPOT_ENABLE" = "true" ]; then
echo "CCSP-HOTSPOT-RESTART"
Restart_Hostapd
/lib/rdk/handle_emu_gre.sh create
echo "CCSP-HOTSPOT IS SUCCESSFULLY RUNNING"
fi

