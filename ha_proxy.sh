#!/bin/bash

# Install HAProxy
sudo dnf install -y haproxy

# Configure HAProxy
cat << EOF | sudo tee /etc/haproxy/haproxy.cfg
global
  log /dev/log local0
  log /dev/log local1 notice
  chroot /var/lib/haproxy
  stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
  stats timeout 30s
  user haproxy
  group haproxy
  daemon

defaults
  log global
  mode http
  option httplog
  option dontlognull
  timeout connect 5000
  timeout client 50000
  timeout server 50000

frontend http-in
  bind *:80
  default_backend servers

backend servers
  balance roundrobin
  server server1 192.168.1.101:80 check
  server server2 192.168.1.102:80 check
  server server3 192.168.1.103:80 check
EOF

# Restart HAProxy
sudo systemctl restart haproxy
