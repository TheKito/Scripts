#!/bin/bash
IPTABLES=$(which "iptables")
wget --inet4-only -q https://www.cloudflare.com/ips-v4 -O - | while read ip
do
        $IPTABLES -A INPUT  -p tcp --dport 80  -s $ip -j ACCEPT
        $IPTABLES -A INPUT  -p tcp --dport 443 -s $ip -j ACCEPT
done
