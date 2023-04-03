#!/bin/bash

# Install PHP and required modules
sudo dnf install -y php php-fpm php-mysqlnd php-opcache php-xml php-gd php-mbstring

# Configure PHP-FPM
sudo sed -i 's/^listen = .*/listen = \/run\/php-fpm\/php-fpm.sock/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^listen\.owner = .*/listen.owner = nginx/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^listen\.group = .*/listen.group = nginx/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^user = .*/user = nginx/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^group = .*/group = nginx/' /etc/php-fpm.d/www.conf

# Configure Nginx to use PHP-FPM
sudo tee /etc/nginx/conf.d/default.conf <<EOF
server {
    listen       80;
    server_name  localhost;
    root   /var/www/html;

    location / {
        index  index.php index.html index.htm;
    }

    error_page  404              /404.html;
    location = /404.html {
        internal;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        internal;
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_pass unix:/run/php-fpm/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

# Restart PHP-FPM and Nginx
sudo systemctl restart php-fpm
sudo systemctl restart nginx
