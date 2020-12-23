#!/bin/sh
function modify_config() {
    sed -i -e "/$1 =/ s/= .*/= $2/" $3
    sed -i -e "/$1 =/ s/#//g" $3 
}

function get_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$NAME" == "CentOS Linux" ] || [ "$NAME" == "Ubuntu" ]; then
            echo "$NAME"
        else
            echo "System not supported yet"
            exit
        fi
    fi
}

function get_packages_manager() {
    os_name=$1
     if [ $os_name == "Centos Linux" ];
     then
        echo "yum"
     elif [ $os_name == "Ubuntu" ]; 
     then
        echo "apt-get"
     else
        echo "System not supported"
        exit
     fi
}

function install() {
    service_name=$1
    os_name=$2
    dependencies=$3
    repos=$4
    package_manager=$(get_packages_manager $os_name)
    # Full uninstall percona server if alredy exist
    if command -v "$service_name" &> /dev/null
    then
        service $service_name stop
    fi
    package_manager update -y
    for i in dependencies
    do
        $package_manager remove $i*
        $package_manager purge $i*
        $package_manager install $i -y
    done
    for i in repos
    do
        $package_manager install $i -y
        IFS='/' read -ra ADDR <<< "$i"

        # Split url and get the repository's name
        len=${#ADDR[@]}
        repos_name=${ADDR[len-1]}
        dpkg -i repos_name
    done
    service $service_name start &&
    pidof $service_name >/dev/null && echo "$service_name is running" || echo "$service_name NOT running"
}