#/bin/bash

echo "
deb http://deb.debian.org/debian/ stable main
deb-src http://deb.debian.org/debian/ stable main

deb http://security.debian.org/debian-security stable-security/updates main
deb-src http://security.debian.org/debian-security stable-security/updates main
" > /etc/apt/sources.list

mkdir -p /opt/kito/scripts/

echo "#/bin/bash

export DEBIAN_FRONTEND=noninteractive;

apt-get update
apt-get upgrade -dy
apt-get dist-upgrade -dy
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y

test -f /var/run/reboot-required && reboot

" > /opt/kito/scripts/upgradeSystem.sh

chmod +x /opt/kito/scripts/upgradeSystem.sh

apt-get install cron -y

cat /etc/crontab | grep "/opt/kito/scripts/upgradeSystem.sh"          || (echo "$(shuf -i 0-59 -n 1) $(shuf -i 0-23 -n 1)      * * $(shuf -i 0-6 -n 1) root    /opt/kito/scripts/upgradeSystem.sh" >> /etc/crontab) && (/etc/init.d/cron reload)

/opt/kito/scripts/upgradeSystem.sh
