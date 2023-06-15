#!/bin/bash

# Step 1: Install Apache
sudo dnf install httpd

# Step 2: Configure Apache
echo "<VirtualHost *:80>
    ServerName your-onion-site
    DocumentRoot /var/www/html/your-onion-site

    <Directory /var/www/html/your-onion-site>
        AllowOverride All
    </Directory>
</VirtualHost>" | sudo tee /etc/httpd/conf.d/your-site.conf

# Step 3: Install and Configure Tor
sudo dnf install tor

echo "HiddenServiceDir /var/lib/tor/your-onion-site
HiddenServicePort 80 127.0.0.1:80" | sudo tee -a /etc/tor/torrc

sudo systemctl enable tor
sudo systemctl start tor

# Step 4: Publish the Onion Website
sudo cat /var/lib/tor/your-onion-site/hostname

# Step 5: Start Apache
sudo systemctl enable httpd
sudo systemctl start httpd
