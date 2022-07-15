#!/bin/bash
set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
export PATH=$PATH:/usr/local/share/openvswitch/scripts
export PATH=$PATH:/usr/local/share/ovn/scripts


proc_num=$(ps -ef | grep 'ovsdb-server -vconsole:off' | grep -v grep | wc -l)
test $proc_num -gt 0 && ( echo 'ovn-controller is running '; kill -15 $$ )

#         --db-ic-nb-port=6645 \
#         --db-ic-sb-port=6646 \

ovn-ctl start_ic_ovsdb

ovn-ic-nbctl set-connection ptcp:6645

ovn-ic-sbctl set-connection ptcp:6646

ovn-ic-nbctl get-connection
ovn-ic-nbctl get-ssl
ovn-ic-sbctl get-connection
ovn-ic-sbctl get-ssl


exit 0

# example
ovn-ic-nbctl --if-exists ts-del ts1
ovn-ic-nbctl ts-add ts1
ovn-ic-sbctl show



ovn-ctl   \
    --db-ic-sb-create-insecure-remote=yes \
    --db-ic-nb-create-insecure-remote=yes \
    start_ic_ovsdb

ovn-ic-sbctl show


# ovn-ctl --ovn-ic-nb-db=<IC-NB> --ovn-ic-sb-db=<IC-SB> \
#           --ovn-northd-nb-db=<NB> --ovn-northd-sb-db=<SB> [more options] start_ic

#ovn-ctl --ovn-ic-nb-db=tcp:$ip:6645 --ovn-ic-sb-db=tcp:$ip:6646  start_ic

