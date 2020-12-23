
#!/bin/sh
. ./mysql.sh --source-only
. ./postfix.sh --source-only
. ./helper.sh --source-only
. ./ip_table.sh --source-only
# update
# check service unistall
function main() {
    os_name=$(get_system)
    install_mysql "$os_name"
    install_postfix "$os_name"
    install_ip_table "$os_name"
    }
main
exit
