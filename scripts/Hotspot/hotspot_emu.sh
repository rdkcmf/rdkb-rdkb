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



sleep 30

VIRTUAL_INTERFACE_2G=`cat /etc/hostapd_2.4G.conf | grep -w bss | head -1 | cut -d '=' -f2`
INTERFACE_5G=`cat /etc/hostapd_xfinity_5G.conf | grep -w interface | head -1 | cut -d '=' -f2`

HOTSPOT_ENABLE=`dmcli simu getv Device.DeviceInfo.X_COMCAST_COM_xfinitywifiEnable | grep value | cut -f3 -d : | cut -f2 -d" "`
if [ "$HOTSPOT_ENABLE" = "true" ]; then
echo "CCSP-HOTSPOT"
/lib/rdk/handle_emu_gre.sh create
echo "CCSP-HOTSPOT IS SUCCESSFULLY RUNNING"
else
echo "wlan0_0 status is down state"
ifconfig $VIRTUAL_INTERFACE_2G down
ifconfig $INTERFACE_5G down
fi


