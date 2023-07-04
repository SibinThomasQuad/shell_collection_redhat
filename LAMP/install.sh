#!/bin/bash

# Update package repositories
dnf update -y

# Install Apache
dnf install httpd -y

# Enable required Apache modules
systemctl enable --now httpd
dnf install mod_proxy_fcgi mod_setenvif mod_rewrite mod_headers -y

# Install PHP-FPM and multiple PHP versions
dnf install php php-cli php-fpm -y
dnf install php74-php-fpm php74-php-cli php80-php-fpm php80-php-cli -y

# Configure PHP-FPM pools for multiple PHP versions
cat <<EOF > /etc/php-fpm.d/php74.conf
[php74]
user = apache
group = apache
listen = /run/php/php74-fpm.sock
listen.owner = apache
listen.group = apache
php_admin_value[upload_max_filesize] = 32M
php_admin_value[post_max_size] = 32M
php_admin_value[memory_limit] = 256M
EOF

cat <<EOF > /etc/php-fpm.d/php80.conf
[php80]
user = apache
group = apache
listen = /run/php/php80-fpm.sock
listen.owner = apache
listen.group = apache
php_admin_value[upload_max_filesize] = 32M
php_admin_value[post_max_size] = 32M
php_admin_value[memory_limit] = 256M
EOF

# Restart PHP-FPM
systemctl restart php74-php-fpm
systemctl restart php80-php-fpm

# Install MariaDB (drop-in replacement for MySQL)
dnf install mariadb-server -y

# Secure MariaDB installation (optional)
mysql_secure_installation

# Install phpMyAdmin
dnf install phpmyadmin php-json php-mbstring php-zip php-gd -y

# Configure phpMyAdmin Apache integration
echo 'Include /etc/httpd/conf.d/phpMyAdmin.conf' >> /etc/httpd/conf/httpd.conf

# Restart Apache
systemctl restart httpd

# Install FTP server (vsftpd)
dnf install vsftpd -y

# Configure FTP server (optional)
# Modify /etc/vsftpd/vsftpd.conf to suit your needs

# Restart FTP server
systemctl restart vsftpd

# Install SSH server (openssh-server)
dnf install openssh-server -y

# Configure SSH server (optional)
# Modify /etc/ssh/sshd_config to suit your needs

# Restart SSH server
systemctl restart sshd

# Install and configure Apache ModSecurity
dnf install mod_security -y

# Enable ModSecurity
ln -s /usr/share/mod_security/activated_rules/ /etc/httpd/conf.d/

# Enable ModSecurity in Apache
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/httpd/conf.d/mod_security.conf

# Restart Apache
systemctl restart httpd

# Clean up
dnf autoremove -y
