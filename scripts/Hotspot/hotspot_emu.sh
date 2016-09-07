#
# ============================================================================
# COMCAST C O N F I D E N T I A L AND PROPRIETARY
# ============================================================================
# This file and its contents are the intellectual property of Comcast.  It may
# not be used, copied, distributed or otherwise  disclosed in whole or in part
# without the express written permission of Comcast.
# ============================================================================
# Copyright (c) 2015 Comcast. All rights reserved.
# ============================================================================
#



#!/bin/sh

sleep 30

HOTSPOT_ENABLE=`dmcli simu getv Device.DeviceInfo.X_COMCAST_COM_xfinitywifiEnable | grep value | cut -f3 -d : | cut -f2 -d" "`
if [ "$HOTSPOT_ENABLE" = "true" ]; then
echo "CCSP-HOTSPOT"
/lib/rdk/handle_emu_gre.sh create
echo "CCSP-HOTSPOT IS SUCCESSFULLY RUNNING"
fi


