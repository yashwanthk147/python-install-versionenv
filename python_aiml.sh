#!/bin/bash

# Check for Python version and virtual environment name arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <python_version> <venv_name>"
    echo "Example: $0 3.8 my-venv-name-3.8"
    echo "source ~/.venvs/my-venv-name-3.8/bin/activate"
    echo "Example: $0 3.9 my-venv-name-3.9"
    echo "source ~/.venvs/my-venv-name-3.9/bin/activate"
    echo "Example: $0 3.10 my-venv-name-3.10"
    echo "source ~/.venvs/my-venv-name-3.10/bin/activate"
    exit 1
fi

# Extract the Python version and virtual environment name arguments
python_version="$1"
venv_name="$2"
# domain_name="$3"
# PRIVATE_IP="$4"

# Update the apt package list
sudo apt update -y

# Read and install dependencies from dependencies.txt
while read -r dependency; do
    sudo apt install -y "$dependency"
done < dependencies.txt

# Add the deadsnakes PPA for newer Python versions
sudo add-apt-repository ppa:deadsnakes/ppa -y

# Install Python and the corresponding venv package
sudo apt install -y "python$python_version"
sudo apt install -y "python$python_version-venv"

# Create the virtual environment
mkdir -p ~/.venvs
python$python_version -m venv ~/.venvs/$venv_name

# Activate the virtual environment
source ~/.venvs/$venv_name/bin/activate

# Update apt repository
sudo apt update -y

# Install Nginx
sudo apt install nginx -y

# Check firewall list
sudo ufw app list

# Allow Nginx HTTP in firewall
sudo ufw allow 'Nginx HTTP'

# Check Nginx status
sudo systemctl status nginx

# # Create Nginx config file for your specific domain
# sudo tee /etc/nginx/sites-available/${domain_name}.conf <<EOF
# server {
#         server_name ${domain_name}.onpassive.com;
#         location / {
#                proxy_pass http://${PRIVATE_IP}:8080/;
#                proxy_http_version 1.1;
#                proxy_set_header Upgrade \$http_upgrade;
#                proxy_set_header Connection "Upgrade";
#                proxy_set_header Host \$host;
#                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         }
# }
# EOF

# # Create a symbolic link to enable the site
# sudo ln -s /etc/nginx/sites-available/${domain_name}.conf /etc/nginx/sites-enabled/


# Test Nginx config
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

# Display Python version
python3 --version

