#!/bin/bash

# Set the virtual host domain name and root directory
DOMAIN_NAME="example.com"
ROOT_DIR="/var/www/${DOMAIN_NAME}"

# Create the root directory
sudo mkdir -p ${ROOT_DIR}

# Set permissions on the root directory
sudo chown -R apache:apache ${ROOT_DIR}
sudo chmod -R 755 ${ROOT_DIR}

# Create a new virtual host configuration file
sudo tee /etc/httpd/conf.d/${DOMAIN_NAME}.conf <<EOF
<VirtualHost *:80>
    ServerName ${DOMAIN_NAME}
    ServerAlias www.${DOMAIN_NAME}
    DocumentRoot ${ROOT_DIR}

    <Directory ${ROOT_DIR}>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/${DOMAIN_NAME}-error.log
    CustomLog /var/log/httpd/${DOMAIN_NAME}-access.log combined
</VirtualHost>
EOF

# Test the virtual host configuration
sudo apachectl configtest

# If the test passes, reload Apache to apply the new configuration
if [ $? -eq 0 ]
then
    sudo systemctl reload httpd
fi
