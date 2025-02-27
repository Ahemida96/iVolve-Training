#!/bin/bash

apt-get install perl -y # To encrypt the user password

if [ $(id -u) -eq 0 ]; then
    read -p "Enter username : " username
    read -s -p "Enter password : " password
    read -p "Enter group name : " groupname
    egrep "^$username" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        echo "$username exists!"
        exit 1
    else
        egrep "^$groupname" /etc/group >/dev/null
        if [ $? -ne 0 ]; then
            groupadd "$groupname"
            [ $? -eq 0 ] && echo "Group $groupname has been added to system!" || echo "Failed to add group!"
        fi
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        useradd -m -p "$pass" -G "$groupname" "$username"
        [ $? -eq 0 ] && echo "User has been added to system and added to group $groupname!" || echo "Failed to add a user!"
        echo "%$groupname ALL=(ALL) NOPASSWD: /usr/bin/apt-get install nginx" > /etc/sudoers.d/$groupname
        [ $? -eq 0 ] && echo "Group $groupname has been given permission to install nginx without a password!" || echo "Failed to update sudoers file!"
    fi
else
    echo "Only root may add a user to the system."
    exit 2
fi