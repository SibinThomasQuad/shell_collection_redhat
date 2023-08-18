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

# Function to configure Monit for Apache service
configure_monit() {
    # Install Monit if not already installed
    install_monit
    
    # Configure Monit for Apache
    cat << EOF | sudo tee /etc/monit.d/apache
check process httpd with pidfile /run/httpd/httpd.pid
    start program = "/usr/bin/systemctl start httpd"
    stop program = "/usr/bin/systemctl stop httpd"
EOF

    sudo chmod 700 /etc/monit.d/apache
    sudo systemctl restart monit
}

# Main menu
while true; do
    echo "Select an option:"
    echo "1. Configure Monit for Apache service"
    echo "2. Quit"
    read -p "Enter your choice: " choice

    case "$choice" in
        1)
            configure_monit
            ;;
        2)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
