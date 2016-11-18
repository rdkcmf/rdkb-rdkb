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

############ Adding two more IP Address to eth0 Interface ##########

LAN_IP=`cat /var/udhcpd_org.conf | grep router | cut -d ' ' -f3`
ip addr add $LAN_IP/24 dev eth0
ip addr add 192.168.100.1/24 dev eth0

######### Adding default WebUI Access IP in lighttpd Webserver #############

LIGHTTPD_IP=`cat /etc/lighttpd.conf | grep server.bind | grep -v ^# | cut -d '=' -f2`
router_ip_address=`cat /var/udhcpd_org.conf | grep router | cut -d ' ' -f3`
sed -i  "s/server.bind =$LIGHTTPD_IP/server.bind = \"$router_ip_address\"/g" /etc/lighttpd.conf

############## Deleting Wlan0 from Bridge and Killing udhcpc for brlan0 and eth1 #############
brctl delif brlan0 wlan0
ps -eaf | grep ibrlan0 | grep -v grep | awk '{print $2}' | xargs kill -9
ps -eaf | grep ieth1 | grep -v grep | awk '{print $2}' | xargs kill -9

################# Killing udhcpd and adding WAN interface to Bridge ##############
ifconfig eth2 0.0.0.0
brctl addif brlan0 eth2
ifconfig brlan0 0.0.0.0
killall udhcpd


######### Adding default WebUI Access LAN IP in lighttpd Webserver #############
echo "\$SERVER[\"socket\"] == \"192.168.100.1:80\"  { }" >> /etc/lighttpd.conf


############## TURN OFF the Private Wifi ########################
PRIVATE_SSID_OFF=`cat /etc/hostapd.conf | grep ^ssid | head -1`
sed -i "28 s/^/#/" /etc/hostapd.conf

########################## FORWARDING TRAFFIC TO eth0 Interface ##################
WAN_MAC=`ifconfig eth0|grep HWaddr|awk '{print $5}'| tr '[a-z]' '[A-Z]'`
ebtables -t nat -I PREROUTING -i eth1 -p IPv4 --ip-dst $LAN_IP -j dnat --to-dst $WAN_MAC --dnat-target ACCEPT
ebtables -t nat -A PREROUTING -i eth1 -p IPv4 --ip-dst 192.168.100.1 -j dnat --to-dst $WAN_MAC --dnat-target ACCEPT

############### Copying BridgeMode Set-up to default Emulator Set-up ###########
cp /usr/bin/setup_bridgemode.sh /usr/bin/setup.sh

############### Restarting Hostapd and lighttd webserver #########
killall CcspLMLite
Restart_Hostapd
brctl delif brlan0 wlan0

killall lighttpd
