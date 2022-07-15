#!/bin/bash
set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
export PATH=$PATH:/usr/local/share/openvswitch/scripts
export PATH=$PATH:/usr/local/share/ovn/scripts

ovn-ic-sbctl show
ovn-ic-nbctl show

ovn-ctl stop_ic_ovsdb


