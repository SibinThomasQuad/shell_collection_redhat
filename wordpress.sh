#!/bin/bash

# Update system packages
sudo dnf update -y

# Install Apache web server
sudo dnf install -y httpd

# Start and enable Apache service
sudo systemctl start httpd
sudo systemctl enable httpd

# Install MariaDB (MySQL) database server
sudo dnf install -y mariadb-server

# Start and enable MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation

# Install PHP and required extensions
sudo dnf install -y php php-mysqlnd php-json php-gd php-mbstring php-xml php-curl

# Restart Apache service after PHP installation
sudo systemctl restart httpd

# Download and extract the latest WordPress release
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz

# Move WordPress files to the web server root directory
sudo cp -R wordpress/* /var/www/html/

# Set ownership and permissions for WordPress files
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/

# Configure MariaDB for WordPress
sudo mysql -e "CREATE DATABASE wordpress;"
sudo mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'wppassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Clean up temporary files
rm -rf latest.tar.gz wordpress

# Restart Apache service
sudo systemctl restart httpd
