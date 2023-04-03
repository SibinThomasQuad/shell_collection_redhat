#!/bin/bash

# Install Python, pip and Django
sudo dnf install -y python3 python3-pip
sudo pip3 install django

# Create a new Django project
django-admin startproject myproject

# Change into the project directory
cd myproject

# Create a new Django app
python3 manage.py startapp myapp
