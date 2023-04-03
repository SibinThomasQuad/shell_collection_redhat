#!/bin/bash

# Update packages and install required software
sudo yum update -y
sudo yum install -y python3 python3-devel nginx

# Set up virtual environment and activate it
python3 -m venv env
source env/bin/activate

# Install required Python packages
pip install django gunicorn

# Clone your Django app from Git
git clone <your-repository-url>
cd <your-app-name>

# Configure Nginx
sudo tee /etc/nginx/conf.d/<your-app-name>.conf > /dev/null <<EOF
server {
    listen 80;
    server_name <your-domain-name>;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location /static/ {
        alias /path/to/your/static/files/;
    }
}
EOF

# Collect static files for Django app
python manage.py collectstatic --noinput

# Start Gunicorn process
gunicorn --bind 127.0.0.1:8000 <your-app-name>.wsgi:application &

# Restart Nginx
sudo systemctl restart nginx
