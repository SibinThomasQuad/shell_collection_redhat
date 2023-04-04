#!/bin/bash

# Install required packages
sudo dnf install httpd mod_python -y

# Enable CGI module
sudo sed -i 's/^#LoadModule cgi_module/LoadModule cgi_module/' /etc/httpd/conf/httpd.conf

# Restart Apache
sudo systemctl restart httpd

# Configure Apache to allow Python CGI scripts
sudo echo "<Directory /var/www/html>
Options +ExecCGI
AddHandler cgi-script .py
</Directory>" | sudo tee /etc/httpd/conf.d/python-cgi.conf

# Restart Apache
sudo systemctl restart httpd
