#!/bin/bash

# Function to install Monit if not already installed
install_monit() {
    if ! command -v monit &> /dev/null; then
        echo "Monit is not installed. Installing Monit..."
        sudo yum install epel-release -y
        sudo yum install monit -y
    else
        echo "Monit is already installed."
    fi
}

# Function to configure Monit for specific services
configure_monit() {
    local services=("httpd" "mysqld" "nginx")

    for service in "${services[@]}"; do
        if [ -f "/etc/monit.d/${service}" ]; then
            echo "Configuring Monit for ${service}..."
            sudo ln -s /etc/monit.d/${service} /etc/monit.d/monit-${service}
        else
            echo "Monit configuration file for ${service} not found."
        fi
    done

    sudo systemctl restart monit
}

# Main menu
while true; do
    echo "Select an option:"
    echo "1. Install Monit and configure services"
    echo "2. Configure services with existing Monit installation"
    echo "3. Quit"
    read -p "Enter your choice: " choice

    case "$choice" in
        1)
            install_monit
            configure_monit
            ;;
        2)
            configure_monit
            ;;
        3)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
