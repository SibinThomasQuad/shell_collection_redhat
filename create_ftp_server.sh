#!/bin/bash

# Install vsftpd
sudo dnf install -y vsftpd

# Backup the original configuration file
sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

# Configure vsftpd
sudo tee /etc/vsftpd/vsftpd.conf <<EOF
# Allow anonymous FTP
anonymous_enable=YES
anon_root=/var/ftp/pub

# Disable anonymous upload
anon_upload_enable=NO

# Enable local user FTP access
local_enable=YES

# Allow local users to write files
write_enable=YES

# Use FTP over TLS
ssl_enable=YES
rsa_cert_file=/etc/pki/tls/certs/vsftpd.pem
rsa_private_key_file=/etc/pki/tls/private/vsftpd.pem
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
require_ssl_reuse=NO
ssl_ciphers=HIGH

# Enable passive mode
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=31000
EOF

# Create a self-signed SSL certificate
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/tls/private/vsftpd.pem -out /etc/pki/tls/certs/vsftpd.pem -subj "/CN=localhost"

# Set permissions for the FTP directory
sudo chmod 755 /var/ftp
sudo chown ftp:ftp /var/ftp/pub

# Enable and start the vsftpd service
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
