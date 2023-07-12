#!/bin/bash

# Update system packages
sudo dnf update -y

# Install required dependencies
sudo dnf install -y curl policycoreutils openssh-server perl

# Enable and start the SSH service
sudo systemctl enable sshd
sudo systemctl start sshd

# Install GitLab
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://your_server_hostname" dnf install -y gitlab-ee

# Configure GitLab
sudo gitlab-ctl reconfigure

echo "GitLab installation and configuration completed!"
