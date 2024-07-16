#!/bin/bash

# Set up a shared plugin cache directory for Terraform
PLUGIN_CACHE_DIR=~/terraform-plugin-cache

# Create the plugin cache directory if it doesn't exist
mkdir -p $PLUGIN_CACHE_DIR

# Export the TF_PLUGIN_CACHE_DIR environment variable
export TF_PLUGIN_CACHE_DIR=$PLUGIN_CACHE_DIR

# Add the TF_PLUGIN_CACHE_DIR environment variable to ~/.bashrc for persistence
echo 'export TF_PLUGIN_CACHE_DIR=~/terraform-plugin-cache' >> ~/.bashrc

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

# Ensure ~/bin is in your PATH
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
source ~/.bashrc

# Verify the installation
terraform version

# Confirm setup of plugin cache directory
echo "Terraform plugin cache directory is set to: $TF_PLUGIN_CACHE_DIR"
