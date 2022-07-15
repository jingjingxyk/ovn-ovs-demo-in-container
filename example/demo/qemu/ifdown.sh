#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

set -uex


switch='br-int'
ip addr flush dev $1
ip link set $1 down
ovs-vsctl del-port ${switch} $1