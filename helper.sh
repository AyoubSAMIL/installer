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

function run_check_status() {
    service_name=$1
    service $service_name stop
    service $service_name start
    pidof $service_name >/dev/null && echo "$service_name is running" || echo "$service_name NOT running"
}