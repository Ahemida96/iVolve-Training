#!/bin/bash

SUBNET=$(hostname -I | cut -d ' ' -f 1 | cut --complement -d '.' -f 4)

for host in {1..254}; 
do
    # echo "Ping $SUBNET.$host"

    if ping -c 1 $SUBNET.$host &> /dev/null; then
        echo "Server $SUBNET.$host is up and running"
    else
        echo "Server $SUBNET.$host is unreachable"
    fi

done