install_ip_table() {
    os_name=$1
    if [ "$os_name" == "CentOS Linux" ]; then
        yum update -y &&
        yum install iptables
    elif ["$os_name" == "Ubuntu" ]; then
        apt-get update &&
        apt-get install iptables
    else
    echo "System not supported"
    fi
    run_ip_table
}

run_ip_table() {
    run_check_status "iptables"
 }