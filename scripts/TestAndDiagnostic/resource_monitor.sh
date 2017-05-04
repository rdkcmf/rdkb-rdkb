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


TAD_PATH="/lib/rdk"

SELFHEAL_ENABLE=`syscfg get selfheal_enable`

while [ $SELFHEAL_ENABLE == "true" ]
do
        RESOURCE_MONITOR_INTERVAL=`syscfg get resource_monitor_interval`
        if [ "$RESOURCE_MONITOR_INTERVAL" = "" ]
        then
                RESOURCE_MONITOR_INTERVAL=15
        fi
        RESOURCE_MONITOR_INTERVAL=$(($RESOURCE_MONITOR_INTERVAL*60))

        sleep $RESOURCE_MONITOR_INTERVAL
	
        sh $TAD_PATH/task_health_monitor.sh

	SELFHEAL_ENABLE=`syscfg get selfheal_enable`

done

