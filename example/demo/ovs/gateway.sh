#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
set -uex





#  ovs-vsctl set Open_vSwitch . external-ids:ovn-bridge-mappings=external-network-provider:br-ex
#  or
# ovs-vsctl set open . external-ids:ovn-bridge-mappings=external-network-provider:br-provider
# ovs-vsctl --may-exist add-br br-provider
# ovs-vsctl --may-exist add-port br-provider INTERFACE_NAME


#  ovs-vsctl set Open_vSwitch . external-ids:ovn-bridge-mappings=external-network-provider:br-ex
#  or
ovs-vsctl set open . external-ids:ovn-bridge-mappings=external-network-provider:br-provider
ovs-vsctl --may-exist add-br br-provider
ovs-vsctl --may-exist add-port br-provider enp0s8

ip link set dev br-provider up
ip addr add 192.168.3.119/24 dev br-provider
ip addr add 192.168.20.245/24 dev br-provider



