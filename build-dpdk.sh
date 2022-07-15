#!/usr/bin/env bash
set -o pipefail
set -eux

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

apt update -y

apt install -y git curl python3 python3-pip python3-dev wget sudo file
apt install -y libssl-dev ca-certificates

apt install -y \
  git gcc clang make cmake autoconf automake openssl python3 python3-pip unbound libtool \
  openssl netcat curl graphviz libssl-dev libcap-ng-dev
apt install -y net-tools

apt install -y python3 python3-pip python3-setuptools \
  python3-wheel ninja-build doxygen

# pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# pip3 install  meson --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install pyelftools sphinx meson musdk nasm

# 找到site-packages文件的路径
# import site; site.getsitepackages()

apt install -y libnuma-dev libfdt-dev libarchive-dev libbsd-dev libjansson-dev libpcap-dev libisal-dev libibverbs-dev rdma-core
apt install -y libbpf-dev libipsec-mb-dev numactl
apt install -y build-essential

: <<EOF
libmusdk-dev
IPSec_MB  https://github.com/intel/intel-ipsec-mb.git
libxdp-dev #  https://github.com/xdp-project/xdp-tools.git
libnfb

EOF

# apt install -y libdpdk-dev


: <<EOF
test -d dpdk && rm -rf dpdk
test -d intel-ipsec-mb && rm -rf intel-ipsec-mb
EOF

if test -d dpdk; then
  git -C dpdk pull --depth=1 --progress --rebase=true
  git -C intel-ipsec-mb pull --depth=1 --progress --rebase=true
else
  # https://core.dpdk.org/contribute/
  # https://git.dpdk.org/dpdk/tree/
  git clone git://dpdk.org/dpdk --depth=1 --progress
  git clone https://github.com/intel/intel-ipsec-mb.git --depth=1 --progress
fi


: <<EOF
cd ${__DIR__}/intel-ipsec-mb
make -j $(nproc)
make install
EOF

cd ${__DIR__}/dpdk
test -d build && rm -rf build
meson build

ninja -C build
ninja -C build install
ldconfig
pkg-config --modversion libdpdk
