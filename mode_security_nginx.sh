#!/bin/bash

# Install Nginx
sudo dnf install -y nginx

# Install ModSecurity
sudo dnf install -y mod_security mod_security_nginx

# Create the ModSecurity configuration file
sudo tee /etc/nginx/modsec/main.conf <<EOF
SecRuleEngine On
EOF

# Add the ModSecurity configuration to Nginx
sudo tee /etc/nginx/conf.d/modsecurity.conf <<EOF
location / {
    ModSecurityEnabled on;
    ModSecurityConfig /etc/nginx/modsec/main.conf;
}
EOF

# Test the ModSecurity configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
