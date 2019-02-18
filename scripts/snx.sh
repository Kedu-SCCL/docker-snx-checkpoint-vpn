#!/bin/bash

#    Copyright 2019 Kedu S.C.C.L.
#
#    This file is part of Docker-snx-checkpoint-vpn.
#
#    Docker-snx-checkpoint-vpn is free software: you can redistribute it
#    and/or modify it under the terms of the GNU General Public License
#    as published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    Docker-snx-checkpoint-vpn is distributed in the hope that it will be
#    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Docker-snx-checkpoint-vpn. If not, see
#    <http://www.gnu.org/licenses/>.
#
#    info@kedu.coop

server=$SNX_SERVER
user=$SNX_USER
password=$SNX_PASSWORD
snx_command=""
certificate_path="/certificate.p12"

if [ -f "$certificate_path" ]; then
    if [ ! -z "$user" ]; then
        snx_command="snx -s $server -u $user -c $certificate_path"
    else
        snx_command="snx -s $server -c $certificate_path"
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
