#!/bin/bash
set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

# server
socat -d -d  openssl-listen:65532,reuseaddr,fork UNIX-CONNECT:/usr/local/var/run/ovn/ovnsb_db.sock


socat -d -d  openssl-listen:65533,reuseaddr,fork UNIX-CONNECT:/usr/local/var/run/ovn/ovnnb_db.sock


# client

command=socat UNIX-LISTEN:/usr/local/var/run/ovn/ovnsb_db.sock,fork,reuseaddr,unlink-early,mode=777 tcp4:192.168.3.243:65532

command=socat UNIX-LISTEN:/usr/local/var/run/ovn/ovnnb_db.sock,fork,reuseaddr,unlink-early,mode=777 tcp4:192.168.3.243:65533
