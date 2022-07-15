# ovn for docker 
> ovn ovs for docker demo 
> 

## tcpdump for ovs 
```shell
tcpdump -i genev_sys_6081 -vvnn icmp

tcpdump -i eth0 -vvvnnexx


tcpdump -i eth0 -nnn udp  port 6081

```

## reference 
1. [virtual-network-distributed-gateway-router](https://developers.redhat.com/blog/2018/11/08/how-to-create-an-open-virtual-network-distributed-gateway-router#setup_details)
1. [ovs-docker](https://github.com/jingjingxyk/ovs/blob/dev/utilities/ovs-docker)
1. [Open vSwitch with KVM](https://docs.openvswitch.org/en/latest/howto/kvm/)
1. [Open vSwitch with SSL](https://docs.openvswitch.org/en/latest/howto/ssl/)
1. [Using Open vSwitch with DPDK](https://docs.openvswitch.org/en/latest/howto/dpdk/)
1. [ovn-bridge-mappings](https://www.openvswitch.org/support/dist-docs-2.5/ovn-controller.8.txt)