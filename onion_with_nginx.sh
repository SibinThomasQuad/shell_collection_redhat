#!/bin/bash

# Step 1: Install Nginx
sudo dnf install nginx

# Step 2: Configure Nginx
echo "server {
    listen 80;
    server_name your-onion-site;

    location / {
        root /usr/share/nginx/html/your-onion-site;
        index index.html;
    }
}" | sudo tee /etc/nginx/conf.d/your-site.conf

# Step 3: Install and Configure Tor
sudo dnf install tor

echo "HiddenServiceDir /var/lib/tor/your-onion-site
HiddenServicePort 80 127.0.0.1:80" | sudo tee -a /etc/tor/torrc

sudo systemctl enable tor
sudo systemctl start tor

# Step 4: Publish the Onion Website
sudo cat /var/lib/tor/your-onion-site/hostname

# Step 5: Start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
