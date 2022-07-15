#!/bin/bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}
set -uex



ovs-dpctl show
ovs-dpctl dump-flows

ovs-ofctl dump-flows br-int
ovs-appctl ofproto/list-tunnels
ovs-appctl ofproto/trace ovs-dummy