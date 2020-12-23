function install_mysql() {
    os_name=$1
    if [ "$os_name" == "CentOS Linux" ];
    then
        install_mysql_yum
    elif [ "$os_name" == "Ubuntu" ];
    then
        install_mysql_apt
    else 
        echo "System not supported"
        exit
    fi
}

install_mysql_apt() {
# Full uninstall percona server if alredy exist
if command -v "mysql" &> /dev/null
then
service mysql stop
apt-get remove percona-server*
apt-get purge percona-server*
fi

# variable for the root password
dbpass="root"

# Install the OS updates
apt-get update && apt-get upgrade -y

# Set the timezone to CST
echo "Africa/Casablanca" > /etc/timezone

dpkg-reconfigure -f noninteractive tzdata

# Install needed packages
apt-get install gnupg2
apt-get install debconf-utils

# Install noninteractive
export DEBIAN_FRONTEND=noninteractive

# Fetch the Percona repository
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb

# Install the downloaded package with dpkg.
dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb

# Update the local cache
apt-get update

# Install essential packages
apt-get -y install zsh htop

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
debconf-set-selections <<< "percona-server-server-5.6 percona-server-server/root_password password root"
debconf-set-selections <<< "percona-server-server-5.6 percona-server-server/root_password_again password root"

apt-get -y install percona-server-server-5.6 &&
run_check_status "mysql" &&
secure_mysql $dbpass "Ubuntu"
}

install_mysql_yum() {
# Full uninstall percona server if alredy exist
if command -v "mysqld" &> /dev/null
then
systemctl stop mysqld
yum remove percona-server*
rm -rf /var/lib/mysql
rm -f /etc/my.cnf
fi

# variable for the root password
dbpass="root"

# Install the OS updates
yum update && yum upgrade -y

# Set the timezone to CST
echo "Africa/Casablanca" > /etc/timezone

dpkg-reconfigure -f noninteractive tzdata

# Install needed packages
yum install gnupg2
yum install debconf-utils

# Install noninteractive
export DEBIAN_FRONTEND=noninteractive

# Fetch the Percona repository
yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm -y

# Install the downloaded package with dpkg.
percona-release setup ps80 &&
percona-release enable-only tools release &&
yum install percona-xtrabackup-80 &&
run_check_status "mysqld" &&
secure_mysql $dbpass "CentOS Linux"
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