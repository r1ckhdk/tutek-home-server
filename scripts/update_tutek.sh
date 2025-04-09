#!/bin/bash

set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi


echo "Updating apt repositories..."
apt-get update

echo "Upgrading packages..."
apt-get upgrade -y

echo "Removing non-used packages..."
apt-get autoremove -y

echo "Cleaning old packages..."
apt-get autoclean


echo "Update finished"
