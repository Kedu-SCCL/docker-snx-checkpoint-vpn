#!/bin/bash
server=$SNX_SERVER
user=$SNX_USER
password=$SNX_PASSWORD
certificate=$SNX_CERTIFICATE
snx_command=""

if [ ! -z "$certificate" ]; then
    if [ ! -z "$user" ]; then
        snx_command="snx -s $server -u $user -c /$certificate"
    else
        snx_command="snx -s $server -c /$certificate"
    fi
else
    snx_command="snx -s $server -u $user"
fi

/usr/bin/expect <<EOF
spawn $snx_command
expect "*?assword:"
send "$password\r"
expect "*Do you accept*"
send "y\r"
expect "SNX - connected."
interact
EOF

iptables -t nat -A POSTROUTING -o tunsnx -j MASQUERADE
iptables -A FORWARD -i eth0 -j ACCEPT

/bin/bash
