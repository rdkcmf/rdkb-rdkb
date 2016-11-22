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

Restart_Hostapd () {                                                      
                                                                          
                                                                          
        ifconfig mon.wlan0 down                                           
        ps -eaf | grep host | grep -v grep | awk '{print $2}' | xargs kill -9
        ifconfig wlan0 down                                                  
        ifconfig wlan0_0 down                                             
                                                                          
        ifconfig wlan0 up                                                 
        hostapd -B /etc/hostapd.conf                                      
        ifconfig mon.wlan0 up                                             
        ifconfig wlan0_0 up                                                  
                                                                             
        ps -eaf | grep host | grep -v grep | awk '{print $2}' | xargs kill -9
        ifconfig wlan0 up                                                    
        hostapd -B /etc/hostapd.conf                                         
        ifconfig mon.wlan0 up                                                
        ifconfig wlan0_0 up                                                  
}                                                                            
                                                                             
Hostapd_Restart () {                                                         
                                                                             
        ps -eaf | grep host | grep -v grep | awk '{print $2}' | xargs kill -9
        ifconfig wlan0 up                                                    
        hostapd -B /etc/hostapd.conf                                         
        ifconfig mon.wlan0 up                                                
        ifconfig wlan0_0 up                                                  
                                                                             
}          

ROUTER=`cat /etc/udhcpd.conf | grep router | cut -d ' ' -f3`
SUBNETMASK=`cat /etc/udhcpd.conf | grep subnet | cut -d ' ' -f3`
psmcli nosubsys set dmsb.dhcpv4.server.pool.0.IPRouters $ROUTER
psmcli nosubsys set dmsb.dhcpv4.server.pool.0.SubnetMask $SUBNETMASK

############ Deleting BridgeMode Interface and Adding Wireless Interface to Bridge ########
brctl delif brlan0 eth2
brctl addif brlan0 wlan0


################### Getting Current Router IP Address ##########
udhcpd_conf_file=/etc/udhcpd.conf                                          
KEYWORD=router 
router_ip_address=`grep $KEYWORD $udhcpd_conf_file | cut -d ' ' -f 3`
ifconfig brlan0 $router_ip_address 

######## Remove Additional IP Address from eth0 #############
ip addr del $router_ip_address/24 dev eth0
ip addr del 192.168.100.1/24 dev eth0


################## TURN ON the Private SSID ###############
PRIVATE_SSID_ON=`cat /etc/hostapd.conf | grep ^#ssid`
#sed -i "/$PRIVATE_SSID_ON/ s/^#*//" /etc/hostapd.conf
sed -i "28 s/^#*//" /etc/hostapd.conf

############# Setting Default WebUI access IP in Lighttpd Webserver ########
LIGHTTPD_IP=`cat /etc/lighttpd.conf | grep server.bind | grep -v ^# | cut -d '=' -f2`
sed -i  "s/server.bind =$LIGHTTPD_IP/server.bind = \"$router_ip_address\"/g" /etc/lighttpd.conf

######### Remove the Additional IP Address of eth0 Interface ######
sed -i '$d' /etc/lighttpd.conf 

############### Remove ebtables rules ##################
WAN_MAC=`ifconfig eth0|grep HWaddr|awk '{print $5}'| tr '[a-z]' '[A-Z]'`
ebtables -t nat -D PREROUTING -i eth1 -p IPv4 --ip-dst $router_ip_address -j dnat --to-dst $WAN_MAC --dnat-target ACCEPT
ebtables -t nat -D PREROUTING -i eth1 -p IPv4 --ip-dst 192.168.100.1 -j dnat --to-dst $WAN_MAC --dnat-target ACCEPT


############### Copying RouterMode Set-up to default Emulator Set-up #######
cp /usr/bin/setup_routermode.sh /usr/bin/setup.sh

################# starting The Lighttpd Webserver and Udhcpd ##############
#udhcpd -f /etc/udhcpd.conf &
/usr/bin/CcspLMLite &
killall dnsmasq
/usr/bin/dnsmasq -N -a 127.0.0.1 -z 

Restart_Hostapd                                                              
                                                                             
################# Checking the Hostapd Status Again(due to wlan0 getting failure status) #########################
                                                                                                                              
HOTSPOT_RESTART=`ifconfig wlan0 | grep RUNNING | tr -s ' ' | cut -d " " -f4`                                                
while [ "$HOTSPOT_RESTART" != "RUNNING" ]                                                                                     
do                                                                                                                            
Hostapd_Restart                                                                                                               
HOTSPOT_RESTART=`ifconfig wlan0 | grep RUNNING | tr -s ' ' | cut -d " " -f4`                                                
done    

killall lighttpd
