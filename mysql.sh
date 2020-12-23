#!/bin/sh
service_name="mysql"
declare -a dependencies=("gnupg2" "percona-server-server-5.6")
declare -a repos=("https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb")

function install_mysql() {
    os_name=$1
    if [os_name == "Centos Linux"];then
        $service_name="mysqld"
        $repos=("https://repo.percona.com/yum/percona-release-latest.noarch.rpm")
    fi 
    install $service_name $os_name $dependencies $repos
    secure_mysql "root" $os_name
}

secure_mysql() {
dbpass=$1
os_name=$2
if [ "$os_name" == "CentOS Linux" ]; then
grep "temporary password" /var/log/mysqld.log
mysql_secure_installation
else
# SQL statements to secure the installation
mysql -uroot -p"$dbpass"<< EOF_MYSQL
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF_MYSQL
fi
}