. ./helper.sh --source-only

service_name="postfix"
package_name="postfix"
POSTFIX_CONFIG_FILE="/etc/postfix/main.cf"

function install_postfix() {
    os_name=$1
    install $service_name $os_name &&
    configure_postfix
}

function configure_postfix() {
    modify_config "mydomain" "pimarketing.com" $POSTFIX_CONFIG_FILE &&
    modify_config "myhostname" "ayoub.pimarketing.com" $POSTFIX_CONFIG_FILE
}