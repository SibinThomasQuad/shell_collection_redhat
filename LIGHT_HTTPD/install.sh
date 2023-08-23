#!/bin/bash

# Install Lighttpd and PHP on AlmaLinux
yum install -y epel-release
yum install -y lighttpd php php-common php-cgi php-mysql

# Backup the original Lighttpd configuration
cp /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.backup

# Configure Lighttpd to work with PHP
echo 'server.modules += ( "mod_fastcgi" )' >> /etc/lighttpd/lighttpd.conf
echo 'index-file.names += ( "index.php" )' >> /etc/lighttpd/lighttpd.conf
echo 'server.modules += ( "mod_rewrite" )' >> /etc/lighttpd/lighttpd.conf
echo 'url.rewrite-if-not-file += ( "(.*)" => "/index.php/$1" )' >> /etc/lighttpd/lighttpd.conf
echo 'fastcgi.server = ( ".php" => ( "localhost" => ( "socket" => "/var/run/php-fcgi.sock", "bin-path" => "/usr/bin/php-cgi" ) ) )' >> /etc/lighttpd/lighttpd.conf

# Create the PHP FastCGI socket
touch /var/run/php-fcgi.sock
chown lighttpd:lighttpd /var/run/php-fcgi.sock

# Start Lighttpd service
systemctl start lighttpd
systemctl enable lighttpd

echo "Lighttpd installation and PHP configuration completed."
