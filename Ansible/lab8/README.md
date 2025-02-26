# Lab 8: Using Ansible to Install MySQL and Configure Database

This lab demonstrates how to use Ansible to install MySQL, create a database, and set up a user with encrypted sensitive data using Ansible Vault.

## Prerequisites

- Ansible installed on your control node.
- SSH access to the managed nodes.
- Ansible Vault for encrypting sensitive data.

## Inventory

Create an inventory file named `inventory` with the following content:

```ini
[managed_nodes]
db01 ansible_host=192.168.74.135 ansible_user=ahemida96 ansible_ssh_private_key_file=/home/ahemida96/.ssh/id_rsa
```
This file specifies the target node (`db01`) with its IP address and SSH details.

## Ansible Configuration

Create an `ansible.cfg` file with the following content:

```ini
[defaults]
inventory = inventory
become = true
become_method = sudo
become_user = root
become_ask_pass = false
```
This configuration sets the inventory file, enables privilege escalation, and specifies the method and user for escalation.

## Playbook

Create a playbook file named `playbook.yaml` with the following content:

```yaml
---
- name: Configure DB Server
    hosts: all
    become: true
    vars_files:
        - secret.yaml
    tasks:
        - name: Ubuntu Update
            apt:
                update_cache: yes
                cache_valid_time: 86400

        - name: Install MySQL Server and Required Packages
            apt:
                name:
                    - mysql-server
                    - mysql-client
                    - python3-pymysql
                    - python3
                state: present

        - name: "Start MySQL Service"
            service:
                name: mysql
                state: started
                enabled: true

        - name: Set MySQL root password
            mysql_user:
                login_user: root
                login_password: "{{ mysql_root_password }}"
                name: root
                host: localhost
                password: "{{ mysql_root_password }}"
                login_unix_socket: /var/run/mysqld/mysqld.sock
            notify:
                - restart mysql
            
        - name: Create MySQL User
            mysql_user:
                name: "{{ mysql_user }}"
                password: "{{ mysql_user_password }}"
                host: "%"
                priv: "{{ database_name }}.*:ALL"
                state: present
                login_user: root
                login_password: "{{ mysql_root_password }}"

        - name: Create MySQL Database
            mysql_db:
                name: "{{ database_name }}"
                check_implicit_admin: true
                login_user: "{{ mysql_user }}"
                login_password: "{{ mysql_user_password }}"
                state: present

    handlers:
        - name: restart mysql
            service: 
                name: mysqld
                state: restarted
```

This playbook includes tasks to:

	- Update the Ubuntu package cache.
	- Install MySQL server and required packages.
	- Start the MySQL service.
	- Set the MySQL root password.
	- Create a MySQL user.
	- Create a MySQL database.

## Encrypting Sensitive Data

Create a `secret.yaml` file with the following content:

```yaml
mysql_root_password: your_root_password
mysql_user: ivolve_user
mysql_user_password: your_user_password
database_name: ivolve_db
```

Encrypt the `secret.yaml` file using Ansible Vault:

```sh
ansible-vault encrypt secret.yaml
```

## Running the Playbook

Run the playbook with the following command:

```sh
ansible-playbook  -i inventory playbook.yaml --ask-vault-pass
```

This will prompt you for the vault password to decrypt the `secret.yaml` file and execute the playbook.

## By following this lab, you have successfully installed MySQL, created a database, and set up a user using Ansible with encrypted sensitive data.