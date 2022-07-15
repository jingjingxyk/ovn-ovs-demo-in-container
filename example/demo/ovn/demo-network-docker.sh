#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
set -uex


ovn-nbctl list dhcp_options | grep _uuid | awk '{print $3}' | xargs -i ovn-nbctl dhcp-options-del {}


ovn-nbctl --if-exists ls-del ls10
ovn-nbctl ls-add ls10


ipv4_num=$(ovn-nbctl --bare --columns=_uuid find dhcp_options cidr="192.168.20.0/24" | wc -l )

if test $ipv4_num -ne 1
then
{
    test $ipv4_num -gt 1 && ovn-nbctl --bare --columns=_uuid find dhcp_options cidr="192.168.20.0/24" | awk '{print $1}' | xargs -i ovn-nbctl dhcp-options-del {}
    ovn-nbctl dhcp-options-create "192.168.20.0/24"
}
fi
CIDR_IPV4_UUID=$(ovn-nbctl --bare --columns=_uuid find dhcp_options cidr="192.168.20.0/24")


#server_id– 虚拟 dhcp 服务器的 ip 地址
#server_mac– 虚拟 dhcp 服务器的 MAC 地址
#lease_time– DHCP 租约的生命周期
#router键提供有关默认网关的信息

ovn-nbctl dhcp-options-set-options ${CIDR_IPV4_UUID} \
  lease_time=3600 \
  router="192.168.20.1" \
  server_id="192.168.20.1" \
  server_mac=ee:ee:02:00:00:01 \
  mtu=1442 \
  dns_server="223.5.5.5"

ovn-nbctl list dhcp_options

ovn-nbctl set logical_switch ls10 \
other_config:subnet="192.168.20.0/24" \
other_config:exclude_ips="192.168.20.244..192.168.20.254"


ovn-nbctl lsp-add ls10 ls10-port1
ovn-nbctl lsp-set-addresses ls10-port1 '00:02:00:00:00:01 192.168.20.2'
ovn-nbctl lsp-set-port-security ls10-port1  '00:02:00:00:00:01 192.168.20.2'
ovn-nbctl lsp-set-dhcpv4-options ls10-port1 $CIDR_IPV4_UUID




#添加第二个 logical port ls10-port2
ovn-nbctl lsp-add ls10 ls10-port2
ovn-nbctl lsp-set-addresses ls10-port2 '00:02:00:00:00:02 192.168.20.3'
ovn-nbctl lsp-set-port-security ls10-port2 '00:02:00:00:00:02 192.168.20.3'
ovn-nbctl lsp-set-dhcpv4-options ls10-port2 $CIDR_IPV4_UUID

#添加第三个 logical port ls10-port3
ovn-nbctl lsp-add ls10 ls10-port3
ovn-nbctl lsp-set-addresses ls10-port3 '00:02:00:00:00:03 192.168.20.4'
ovn-nbctl lsp-set-port-security ls10-port3 '00:02:00:00:00:03 192.168.20.4'
ovn-nbctl lsp-set-dhcpv4-options ls10-port3 $CIDR_IPV4_UUID

ovn-nbctl list logical_switch_port
ovn-nbctl --columns dynamic_addresses list logical_switch_port
ovn-nbctl show

#exit 0


ovn-nbctl --if-exists lr-del lr1
ovn-nbctl lr-add lr1

ovn-nbctl lrp-add lr1 lr1-ls10-port1   ee:ee:02:00:00:01 192.168.20.1/24


ovn-nbctl lsp-add ls10 ls10-lr1-port1
ovn-nbctl lsp-set-type ls10-lr1-port1 router
ovn-nbctl lsp-set-addresses ls10-lr1-port1 router

ovn-nbctl lsp-set-options ls10-lr1-port1 router-port=lr1-ls10-port1



ovn-nbctl lrp-add lr1 lr1-public-port1   ee:ee:01:00:00:02 192.168.20.243/24


ovn-nbctl  --if-exists ls-del  public
ovn-nbctl ls-add public

ovn-nbctl lsp-add public public-lr1-port1
ovn-nbctl lsp-set-type public-lr1-port1 router
ovn-nbctl lsp-set-addresses public-lr1-port1 router
ovn-nbctl lsp-set-options public-lr1-port1 router-port=lr1-public-port1

# connecton 物理网络
# Create a localnet port
ovn-nbctl lsp-add public ln-public
ovn-nbctl lsp-set-type ln-public localnet
ovn-nbctl lsp-set-addresses ln-public unknown
ovn-nbctl lsp-set-options ln-public network_name=external-network-provider

exit 0
ovn-nbctl lrp-set-gateway-chassis lr1-public-port1 de4b8046-3a69-459a-8795-cc5e173019ee 20


exit 0
ovn-trace --summary ls10 '
  inport=="ls10-port2" &&
  eth.src==00:02:00:00:00:02 &&
  ip4.src==0.0.0.0 &&
  ip.ttl==1 &&
  ip4.dst==255.255.255.255 &&
  udp.src==68 &&
  udp.dst==67'


ovn-nbctl list gateway_chassis
ovn-sbctl list chassis
ovn-nbctl find NAT type=snat

ovs-appctl ovs/route/show

ovn-sbctl list port_binding


