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

############################## Restoring Wifi values for Private wifi 2.4Ghz  ######################

############# Restore default ssid ########################################
SSID=`cat /etc/hostapd_2.4G.conf | grep ssid | head -1 | cut -d "=" -f2`
sed -i "28 s/ssid=$SSID/ssid=RDKB-EMU-2.4G/g" /etc/hostapd_2.4G.conf

################# Restore default password ################################
PASSWORD=`cat /etc/hostapd_2.4G.conf | grep wpa_passphrase | cut -d "=" -f2`
sed -i  "s/wpa_passphrase=$PASSWORD/wpa_passphrase=password/g" /etc/hostapd_2.4G.conf    

#################### Restore default Channel ##################################
CHANNEL=`cat /etc/hostapd_2.4G.conf | grep channel | cut -d "=" -f2`
sed -i  "s/channel=$CHANNEL/channel=6/g" /etc/hostapd_2.4G.conf


########################## Reset Wifi  default values into PSM configuration files #########
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.SSID string RDKB-EMU-2.4G
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.Passphrase string password
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.1.Channel uint 6


sleep 5
############################## Restoring Wifi values for Private wifi 5Ghz  ######################

############# Restore default ssid ########################################
SSID=`cat /etc/hostapd_5G.conf | grep ssid | head -1 | cut -d "=" -f2`
sed -i "28 s/ssid=$SSID/ssid=RDKB-EMU-5G/g" /etc/hostapd_5G.conf

################# Restore default password ################################
PASSWORD=`cat /etc/hostapd_5G.conf | grep wpa_passphrase | cut -d "=" -f2`
sed -i  "s/wpa_passphrase=$PASSWORD/wpa_passphrase=5g-password/g" /etc/hostapd_5G.conf

#################### Restore default Channel ##################################
CHANNEL=`cat /etc/hostapd_5G.conf | grep channel | cut -d "=" -f2`
sed -i  "s/channel=$CHANNEL/channel=36/g" /etc/hostapd_5G.conf


########################## Reset Wifi  default values into PSM configuration files #########
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.2.SSID string RDKB-EMU-5G
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.2.Passphrase string 5g-password
dmcli simu psmsetv eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.2.Channel uint 36


sleep 8
