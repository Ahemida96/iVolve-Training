# Jenkins Installation Guide

## Installing Jenkins as a Service

### Prerequisites
- Java Development Kit (JDK) 8 or 11
- wget (to download Jenkins)

### Steps
1. **Add Jenkins Repository Key:**
    ```sh
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    ```

2. **Add Jenkins Repository:**
    ```sh
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    ```

3. **Update Package List:**
    ```sh
    sudo apt-get update
    ```

4. **Install Jenkins:**
    ```sh
    sudo apt-get install jenkins
    ```

5. **Start Jenkins Service:**
    ```sh
    sudo systemctl start jenkins
    ```

6. **Enable Jenkins to Start on Boot:**
    ```sh
    sudo systemctl enable jenkins
    ```

7. **Access Jenkins:**
    Open your browser and go to `http://your_server_ip_or_domain:8080`

### OR You can just run the following script to automate the process
```sh
#!/bin/bash

# Update the package index
sudo apt-get update

# Install Java (Jenkins requires Java to run)
sudo apt-get install -y openjdk-11-jdk

# Add the Jenkins Debian repository and key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update the package index again
sudo apt-get update

# Install Jenkins
sudo apt-get install -y jenkins

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start at boot
sudo systemctl enable jenkins

# Fetch the initial admin password
echo "Fetching the initial admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Installing Jenkins as a Container

### Prerequisites
- Docker installed on your system

### Steps
1. **Pull Jenkins Docker Image:**
    ```sh
    docker pull jenkins/jenkins:lts
    ```

2. **Run Jenkins Container:**
    ```sh
    docker run -d -p 8080:8080 -p 50000:50000 --name jenkins jenkins/jenkins:lts
    ```

3. **Access Jenkins:**
    Open your browser and go to `http://your_server_ip:8080`

### Additional Configuration
- To persist Jenkins data, you can mount a volume:
    ```sh
    docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins:lts
    ```