#!/bin/sh

sleep 20

########### Creating Bridge #####################################
brctl addbr brlan0
WAN_IP=`route -n | grep UG | tr -s ' ' | cut -d ' ' -f2`

########## Adding Route to WAN Interface(eth0) ####################
route del default gw $WAN_IP          
route add default gw $WAN_IP eth0


######### Killing udhcpc for eth1 and brlan0 ########################
ps -eaf | grep ieth1 | grep -v grep | awk '{print $2}' | xargs kill -9
sleep 5
ps -eaf | grep ibrlan0 | grep -v grep | awk '{print $2}' | xargs kill -9

#################### Adding two more IP Address to eth0 Interface ########

LAN_IP=`cat /var/udhcpd_org.conf | grep router | cut -d ' ' -f3`
ip addr add $LAN_IP/24 dev eth0
ip addr add 192.168.100.1/24 dev eth0

######################## Adding physical and WAN Interfaces to Bridge #########
ifconfig eth2 0.0.0.0
brctl addif brlan0 eth2
brctl addif brlan0 eth1


####################### FORWARDING TRAFFIC to eth0 INTERFACE ##########
WAN_MAC=`ifconfig eth0|grep HWaddr|awk '{print $5}'| tr '[a-z]' '[A-Z]'`
ebtables -t nat -I PREROUTING -i eth1 -p IPv4 --ip-dst $LAN_IP -j dnat --to-dst $WAN_MAC --dnat-target ACCEPT
ebtables -t nat -A PREROUTING -i eth1 -p IPv4 --ip-dst 192.168.100.1 -j dnat --to-dst $WAN_MAC --dnat-target ACCEPT

################### Getting wlan0_0 mac Address(public wifi) #############
sh /lib/rdk/Getting_wlan0_0_mac.sh

############################ iptables-restore ########################     
#iptables-restore < /etc/iptables/rules.v4 

###################### Routing Table ##################################
sh /lib/rdk/webgui.sh

