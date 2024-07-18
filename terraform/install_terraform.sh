#!/bin/bash

# Set up a shared plugin cache directory for Terraform
PLUGIN_CACHE_DIR=~/terraform-plugin-cache

# Create the plugin cache directory if it doesn't exist
mkdir -p $PLUGIN_CACHE_DIR

# Export the TF_PLUGIN_CACHE_DIR environment variable
export TF_PLUGIN_CACHE_DIR=$PLUGIN_CACHE_DIR

# Add the TF_PLUGIN_CACHE_DIR environment variable to ~/.bashrc for persistence
if ! grep -q 'export TF_PLUGIN_CACHE_DIR=~/terraform-plugin-cache' ~/.bashrc; then
  echo 'export TF_PLUGIN_CACHE_DIR=~/terraform-plugin-cache' >> ~/.bashrc
fi

# Ensure ~/bin is in your PATH
if ! grep -q 'export PATH=$PATH:~/bin' ~/.bashrc; then
  echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
fi

# Fetch the latest Terraform version
LATEST_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)

# Download the latest Terraform binary
curl -O https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_linux_amd64.zip

# Unzip the downloaded binary
unzip terraform_${LATEST_VERSION}_linux_amd64.zip

# Create the bin directory if it doesn't exist
mkdir -p ~/bin

# Move the Terraform binary to ~/bin
mv terraform ~/bin/

# Verify the installation and confirm setup
echo "Terraform installation complete."
terraform version
