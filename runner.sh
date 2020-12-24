
#!/bin/sh
. ./mysql.sh --source-only
. ./postfix.sh --source-only
. ./helper.sh --source-only
. ./ip_table.sh --source-only

function main() {
    os_name=$(get_system)
    prepare "$os_name"
    install_mysql "$os_name"
    install_postfix "$os_name"
    install_ip_table "$os_name"
    }

function prepare() {
    os_name=$1
    BOOT_DIR="installer"
    if test -d "$BOOT_DIR"; then
        rm -r $BOOT_DIR
    fi
    install "git" "$os_name" ("git") && git clone https://github.com/AyoubSAMIL/installer.git
    cd $BOOT_DIR
    install "dos2unix" "$os_name" ("dos2unix") && dos2unix *.sh && bash runner.sh
}
main
exit
