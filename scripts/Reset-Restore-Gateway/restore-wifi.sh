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

################################## RESTORE DEFAULT WIFI SETTINGS ###########################################

dmcli simu setv Device.WiFi.Radio.1.Channel uint 6
dmcli simu setv Device.WiFi.Radio.5.Channel uint 6
dmcli simu setv Device.WiFi.SSID.1.SSID string RDKB-EMU
dmcli simu setv Device.WiFi.SSID.5.SSID string Xfinity-wifi-2.4G
dmcli simu setv Device.WiFi.AccessPoint.1.Security.X_CISCO_COM_EncryptionMethod string TKIP
dmcli simu setv Device.WiFi.AccessPoint.1.Security.X_CISCO_COM_KeyPassphrase string password
dmcli simu setv Device.WiFi.AccessPoint.1.Security.ModeEnabled string WPA-Personal
