#!/usr/bin/env bash

set -eux
set -o pipefail


## ovn conf dir
#/usr/local/etc/openvswitch
#/usr/local/etc/ovn

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

prepare(){


  apt update -y

  apt install -y git curl python3 python3-pip python3-dev wget   sudo file
  apt install -y libssl-dev ca-certificates

  apt install -y  \
  git gcc clang make cmake autoconf automake openssl python3 python3-pip unbound libtool  \
  openssl netcat curl  graphviz libssl-dev  libcap-ng-dev uuid uuid-runtime
  apt install -y net-tools
  apt install -y kmod iptables

}
test $(dpkg-query -l graphviz | wc -l) -eq 0 && prepare


if test -d ovn
then
    cd ${__DIR__}/ovn/
    git   pull --depth=1 --progress --rebase
    cd ${__DIR__}/ovs/
    git   pull --depth=1 --progress --rebase
else
    git clone -b master https://github.com/openvswitch/ovs.git --depth=1 --progress
    git clone -b main https://github.com/ovn-org/ovn.git --depth=1 --progress
fi

cd ${__DIR__}/ovs/
./boot.sh
cd ${__DIR__}/ovs/
./configure --enable-ssl
make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l`
sudo make install


cd ${__DIR__}/ovn/
./boot.sh
cd ${__DIR__}/ovn/
./configure  --enable-ssl \
--with-ovs-source=${__DIR__}/ovs/ \
--with-ovs-build=${__DIR__}/ovs/

make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l`
sudo make install