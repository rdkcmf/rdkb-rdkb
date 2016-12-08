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

#!/bin/sh

####################### changing BridgeMode to RouterMode ################


echo "IN BRIDGEMODE SCRIPT"
cp -fr /etc/iptables/default_rules.v4 /etc/iptables/rules.v4
rm /etc/dhcp_static_hosts
touch /etc/dhcp_static_hosts

BRIDGEMODE_ENABLE=`dmcli simu psmget dmsb.X_CISCO_COM_DeviceControl.LanManagementEntry.1.LanMode | grep value | cut -f3 -d : | cut -f2 -d" "`

echo "BRIDGEMODE VALUE : $BRIDGEMODE_ENABLE"
if [ "$BRIDGEMODE_ENABLE" = "bridge-static" ]; then

                ###### Changing WebUI Value #########
                dmcli simu psmsetv dmsb.X_CISCO_COM_DeviceControl.LanManagementEntry.1.LanMode string router

                ###### Turn On the Private Wifi #####
                sed -i "28 s/^#*//" /etc/hostapd.conf
		DEFAULT_SSID=`cat /etc/hostapd.conf | grep ssid | head -1`
		sed -i -e "s/$DEFAULT_SSID/ssid=RDKB-EMU/g" /etc/hostapd.conf		
			
		###### Restoring udhcpd and lighttpd Webserver #####
                cp -fr /var/udhcpd_orginal.conf /etc/udhcpd.conf
                sed -i '$d' /etc/lighttpd.conf
		sh /lib/rdk/webgui.sh
                cp /usr/bin/setup_routermode.sh /usr/bin/setup.sh
fi

