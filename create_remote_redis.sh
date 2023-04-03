#!/bin/bash

# Install Redis
sudo dnf install -y redis

# Edit the Redis configuration file
sudo sed -i 's/^# bind .*/bind 0.0.0.0/' /etc/redis.conf

# Enable Redis to start on boot
sudo systemctl enable redis

# Restart Redis
sudo systemctl restart redis
