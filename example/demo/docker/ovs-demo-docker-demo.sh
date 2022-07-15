#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
set -uex


docker run --rm --name ovn-dev-01 --network none --cap-add=NET_ADMIN  registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:debian-11-ovn-dev-20220711T1718Z tail -f /dev/null

ovs-docker add-port br-int eth0  ovn-dev-01 --macaddress='00:02:00:00:00:01' --ipaddress='192.168.20.2/24' --mtu=1450

ovs-vsctl  -- set Port 4c8d64d088f44_l  external_ids:iface-id='ls10-port1' external_ids:attached-mac='00:02:00:00:00:01' external_ids:iface-status=active

docker exec -it ovn-dev-01 bash
ovs-docker del-port br-int eth0  ovn-dev-01

docker run --rm --name ovn-dev-02 --network none --cap-add=NET_ADMIN   registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:debian-11-ovn-dev-20220711T1718Z tail -f /dev/null

ovs-docker add-port br-int eth0  ovn-dev-02 --macaddress='00:02:00:00:00:02' --ipaddress='192.168.20.3/24' --mtu=1450
ovs-vsctl  -- set Port 4c8d64d088f44_l  external_ids:iface-id='ls10-port2'
docker exec -it ovn-dev-02 bash
ovs-docker del-port br-int eth0  ovn-dev-02


container_id=$(docker run --rm  -d --network none  --cap-add=NET_ADMIN  registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:debian-11-ovn-dev-20220711T1718Z tail -f /dev/null)

ovs-docker add-port br-int eth0  $container_id --macaddress='00:02:00:00:00:03'
ovs-vsctl  set Interface 3e6369b103c64_l  external_ids:iface-id='ls10-port3' external-ids:attached-mac='00:02:00:00:00:03' external-ids:iface-status=active
docker exec -it $container_id dhclient -v
docker exec -it $container_id bash
ovs-docker del-port br-int eth0  $container_id



docker inspect -f '{{.State.Pid}}' $container_id

ovs-vsctl set Interface eth0 external-ids:iface-id='"${UUID}"'

ovs-vsctl --columns=name,external-ids list Interface

ovs-vsctl set Interface foo external-ids:iface-id=bar external-ids:iface-status=active external-ids:attached-mac=<mac> external-ids:vm-uuid:<uuid>

ovs-vsctl --columns external_ids list open_vswitch
