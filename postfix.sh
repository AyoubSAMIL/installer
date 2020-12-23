. ./helper.sh --source-only

service_name="postfix"
package_name="postfix"
POSTFIX_CONFIG_FILE="/etc/postfix/main.cf"

function install_postfix() {
    os_name=$1
    if [ "$os_name" == "CentOS Linux" ]; then
        yum update && yum upgrade -y
        yum install $package_name -y
    elif [ "$os_name" == "Ubuntu" ]; then
        apt-get update && apt-get upgrade -y
        apt-get install $package_name -y
    else
        echo "System not supported"
        exit
    fi
    configure_postfix
    run_postfix
}

function run_postfix() {
    run_check_status "postfix"
}

function configure_postfix() {
    modify_config "mydomain" "pimarketing.com" $POSTFIX_CONFIG_FILE &&
    modify_config "myhostname" "ayoub.pimarketing.com" $POSTFIX_CONFIG_FILE
}