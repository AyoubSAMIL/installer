#!/bin/sh
. ./helper.sh --source-only

service_name="iptables"
dependencies=(iptables-services)

install_ip_table() {
    os_name=$1
    install $service_name $os_name $dependencies
}