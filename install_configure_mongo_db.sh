#!/bin/bash

# Import MongoDB GPG key
sudo rpm --import https://www.mongodb.org/static/pgp/server-5.0.asc

# Create MongoDB repository file
sudo tee /etc/yum.repos.d/mongodb-org-5.0.repo <<EOF
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF

# Install MongoDB
sudo dnf install -y mongodb-org

# Configure MongoDB
sudo tee /etc/mongod.conf <<EOF
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  bindIp: 0.0.0.0
security:
  authorization: enabled
EOF

# Start MongoDB and enable it to start at boot
sudo systemctl start mongod
sudo systemctl enable mongod
