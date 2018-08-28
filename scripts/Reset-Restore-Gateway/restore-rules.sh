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


################################## PSM Updation For RESTORE DEFAULT LAN SETTINGS ###########################################

dmcli simu psmsetv Provision.COSALibrary.NAT.PORTTRIGGER.NextInstanceNumber uint 1
dmcli simu psmsetv Device.NAT.PortMapping.MaxInstance string 0
dmcli simu psmsetv dmsb.UserInterface.X_CISCO_COM_RemoteAccess.HttpsEnable string FALSE
dmcli simu psmsetv dmsb.UserInterface.X_CISCO_COM_RemoteAccess.HttpEnable string TRUE
dmcli simu psmsetv dmsb.UserInterface.X_CISCO_COM_RemoteAccess.HttpPort string 8080
dmcli simu psmsetv dmsb.NAT.X_CISCO_COM_DMZ.Enable string FALSE
dmcli simu psmsetv dmsb.nat.X_CISCO_COM_PortTriggers.Enable string 0
dmcli simu psmsetv dmsb.nat.PortMapping.Enable string 0
dmcli simu psmsetv dmsb.X_CISCO_COM_Security.Firewall.FirewallLevel string Low
dmcli simu psmsetv dmsb.dhcpv4.server.pool.1.StaticAddress.InstanceNumber string 0 
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedSites.InstanceNumber string 0
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedSites.TrustedUser.InstanceNumber string 0
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedServices.InstanceNumber string 0
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedServices.TrustedUser.InstanceNumber string 0
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedDevices.InstanceNumber string 0
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedSites.Enable string false
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedServices.Enable string false
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedDevices.Enable string false
dmcli simu psmsetv dmsb.X_Comcast_com_ParentalControl.ManagedDevices.AllowAll string false
dmcli simu psmsetv dmsb.hotspot.tunnel.1.Enable string 1
dmcli simu psmsetv dmsb.users.user.3.password string password
dmcli simu psmsetv Device.DeviceInfo.X_RDKCENTRAL-COM_ConfigureWiFi string true
dmcli simu psmsetv Device.DeviceInfo.X_RDKCENTRAL-COM_CaptivePortalEnable string true

sleep 2

sed -i '$d' /etc/lighttpd.conf
sh /lib/rdk/webgui.sh

if [ -f /nvram/captivemode_enabled ]; then
                rm /nvram/captivemode_enabled
		rm /nvram/updated_captiveportal_redirectionrules
fi  
