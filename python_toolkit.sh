#!/bin/bash

# Update package lists
sudo dnf update -y

# Install Python and pip
sudo dnf install -y python3 python3-pip

# Install development tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y openssl-devel libffi-devel python3-devel

# Install code editors and IDEs
sudo dnf install -y vim nano emacs pycharm-community

# Install version control tools
sudo dnf install -y git

# Install virtual environment tool
sudo dnf install -y python3-virtualenv

# Install package management tool
sudo dnf install -y python3-pip

# Install formatting and linting tools
pip3 install black flake8 pylint

# Install Python testing frameworks
pip3 install pytest coverage

# Install data science and machine learning libraries
pip3 install numpy pandas matplotlib scikit-learn tensorflow

echo "Python developer tools installation complete."
