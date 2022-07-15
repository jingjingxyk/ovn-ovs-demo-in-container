#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
set -uex



container_id=$(docker run --rm  -d --network none  --cap-add=NET_ADMIN  registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:debian-11-ovn-dev-20220711T1718Z tail -f /dev/null)

ovs-docker add-port br-int eth0  $container_id --macaddress='00:02:00:00:00:03'
ovs-vsctl  set Interface 3e6369b103c64_l  external_ids:iface-id='ls10-port3' external-ids:attached-mac='00:02:00:00:00:03' external-ids:iface-status=active

docker exec -it $container_id dhclient -v
docker exec -it $container_id bash


ovs-docker del-port br-int eth0  $container_id

