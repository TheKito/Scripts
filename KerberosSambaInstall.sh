#!/bin/bash

apt update
apt install krb5-user -y
rm /etc/krb5.conf
ln -s /var/lib/samba/private/krb5.conf /etc/krb5.conf
kinit administrator
klist
