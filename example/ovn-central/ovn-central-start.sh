#!/bin/bash
set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
export PATH=$PATH:/usr/local/share/openvswitch/scripts
export PATH=$PATH:/usr/local/share/ovn/scripts

ovn_ic_db_host=192.168.3.244


ovn-ctl \
        --ovn-ic-nb-db=tcp:${ovn_ic_db_host}:6645 \
        --ovn-ic-sb-db=tcp:${ovn_ic_db_host}:6646 \
        start_ic


ovn-ctl start_northd # center need

ovn-nbctl set NB_Global . name=demo-cn-01

#ovn-nbctl set nb_global . ipsec=true
# 要禁用 IPsec
ovn-nbctl set nb_global . ipsec=false

ovn-nbctl set-connection ptcp:6641
ovn-sbctl set-connection ptcp:6642



#cp /usr/local/var/lib/openvswitch/pki/switchca/cacert.pem
#ovn-sbctl set-connection role=ovn-controller pssl:6642


ovn-nbctl show
ovn-sbctl show

sleep 1

netstat -antp | grep 6641
netstat -antp | grep 6642


