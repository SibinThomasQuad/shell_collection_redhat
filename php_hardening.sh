#!/bin/bash

# Install PHP and required extensions
sudo dnf install -y php php-opcache php-fpm php-mbstring php-mysqlnd

# Configure PHP-FPM
sudo sed -i 's/^listen =.*/listen = 127.0.0.1:9000/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php-fpm.d/www.conf

# Enable Opcache
sudo tee /etc/php.d/10-opcache.ini <<EOF
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=128
opcache.max_accelerated_files=10000
opcache.validate_timestamps=1
EOF

# Enable PHP-FPM user and group
sudo sed -i 's/^user =.*/user = apache/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^group =.*/group = apache/' /etc/php-fpm.d/www.conf

# Disable dangerous PHP functions
sudo sed -i 's/^disable_functions =.*/disable_functions = pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,system,shell_exec,passthru,exec,popen,proc_open,parse_ini_file,show_source,stream_socket_server,fsocket/f' /etc/php.ini

# Restart PHP-FPM
sudo systemctl restart php-fpm
