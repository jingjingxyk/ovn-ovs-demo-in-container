#!/bin/bash
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
export PATH=$PATH:/usr/local/share/openvswitch/scripts
export PATH=$PATH:/usr/local/share/ovn/scripts

set -exu
ovn-ctl stop_ic
ovn-ctl stop_northd
sleep 3


#ovn-ctl start_controller_vtep
netstat -antp | grep 6641
netstat -antp | grep 6642


exit 0 ;
