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