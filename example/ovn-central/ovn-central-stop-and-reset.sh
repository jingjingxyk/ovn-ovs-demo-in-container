#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
export PATH=$PATH:/usr/local/share/openvswitch/scripts
export PATH=$PATH:/usr/local/share/ovn/scripts

set -exu

{

  ovn-ctl stop_ic
  ovn-ctl stop_northd
} || {
	echo $?
}

rm -rf /usr/local/etc/ovn/ovnnb_db.db
rm -rf /usr/local/etc/ovn/ovnsb_db.db
