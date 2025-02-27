# Set up Ansible dynamic inventories to automatically discover and manage AWS EC2.

## Steps to Set Up Ansible Dynamic Inventories and Install Apache

1. **Install Ansible and Required Collections**:
    Ensure you have Ansible installed. If not, you can install it from [Here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

    Next, install the `amazon.aws` collection:
    ```sh
    ansible-galaxy collection install amazon.aws
    ```
2. **Install AWS Required Libraries**
    Ensure you have aws cli installed. If not, you can install from [Here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

    Install boto3 and botocore for AWS Inventory
    ```sh
    sudo apt install -y python3-boto3 python3-botocore
    ```

    Verify Installation
    ```sh
    python3 -c "import boto3; print(boto3.__version__)"
    ```

    Configure AWS Credentials
    ```sh
    ~/.aws/credentials
    ```
    or use 
    ```sh
    aws configure --profile user1
    ```

3. **Configure AWS Inventory**:
    Create a file named `aws_inventory.yaml` with the following content to define the dynamic inventory:
    ```yaml
    plugin: amazon.aws.aws_ec2
    regions:
      - us-east-1
    filters:
      instance-state-name: running
    ```

4. **Create the Playbook**:
    Create a file named `playbook.yaml` with the following content to define the tasks for installing Apache:
    ```yaml
    ---
    - name: Install Apache on Running AWS EC2 Instances
      hosts: all
      remote_user: ubuntu
      become: yes
      tasks:
         - name: Install Apache
            apt:
              name: apache2
              state: present
            when: ansible_os_family == "Debian"

         - name: Create index.html
            copy:
              content: "<html><body><h1>iVolve Server...</h1></body></html>"
              dest: /var/www/html/index.html

         - name: Ensure Apache is enabled and started
            service:
              name: apache2
              state: started
              enabled: yes
    ```

4. **Run the Playbook**:
    Execute the playbook using the following command:
    ```sh
    ansible-playbook -i aws_inventory.yaml playbook.yaml
    ```