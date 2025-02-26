# Check Network Hosts' Connectivety

This script is used to check the availability of hosts in a subnet by pinging each host.

## Script Explanation

```bash
#!/bin/bash
```

```bash
SUBNET=$(hostname -I | cut -d ' ' -f 1 | cut --complement -d '.' -f 4)
```
- `hostname -I` retrieves the IP address of the current machine.
- `cut -d ' ' -f 1` extracts the first IP address if there are multiple.
- `cut --complement -d '.' -f 4` removes the last octet of the IP address to get the subnet.

```bash
for host in {1..254}; 
do
```
- This loop iterates over the range of possible host addresses in the subnet (from 1 to 254).

```bash
    # echo "Ping $SUBNET.$host"
```
- This is a commented-out line that would print the ping command being executed.

```bash
    if ping -c 1 $SUBNET.$host &> /dev/null; then
        echo "Server $SUBNET.$host is up and running"
    else
        echo "Server $SUBNET.$host is unreachable"
    fi
```
- `ping -c 1 $SUBNET.$host &> /dev/null` sends one ping packet to the host and discards the output.
- If the ping is successful, it prints that the server is up and running.
- If the ping fails, it prints that the server is unreachable.

```bash
done
```
- Ends the loop.

## Usage

1. Make the script executable: `chmod +x check_hosts.sh`.
2. Run the script: `./check_hosts.sh`.

![Check Hosts](./ping_servers.png)

This will check the availability of all hosts in the subnet of the current machine.
