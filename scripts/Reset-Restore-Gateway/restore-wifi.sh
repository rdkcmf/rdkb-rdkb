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

############################## Restoring Wifi values ######################

############# Restore default ssid ########################################
SSID=`cat /etc/hostapd.conf | grep ssid | head -1 | cut -d "=" -f2`
sed -i "28 s/ssid=$SSID/ssid=RDKB-EMU/g" /etc/hostapd.conf

################# Restore default password ################################
PASSWORD=`cat /etc/hostapd.conf | grep wpa_passphrase | cut -d "=" -f2`
sed -i  "s/wpa_passphrase=$PASSWORD/wpa_passphrase=password/g" /etc/hostapd.conf    

#################### Restore default Channel ##################################
CHANNEL=`cat /etc/hostapd.conf | grep channel | cut -d "=" -f2`
sed -i  "s/channel=$CHANNEL/channel=6/g" /etc/hostapd.conf


########################## Reset Wifi  default values into PSM configuration files #########
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.SSID string RDKB-EMU
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.Passphrase string password
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.1.Channel uint 6


