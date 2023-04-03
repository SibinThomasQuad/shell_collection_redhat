#!/bin/bash

# Install Monit and Nginx
sudo dnf install -y monit nginx

# Configure Monit to monitor Nginx
sudo tee /etc/monit.d/nginx <<EOF
check process nginx with pidfile /var/run/nginx.pid
  start program = "/bin/systemctl start nginx"
  stop program = "/bin/systemctl stop nginx"
  if failed host 127.0.0.1 port 80 protocol http then restart
  if 5 restarts within 5 cycles then timeout
EOF

# Test Monit configuration syntax
sudo monit -t

# Restart Monit to apply changes
sudo systemctl restart monit
