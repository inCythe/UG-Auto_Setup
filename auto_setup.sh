#!/bin/bash

echo "Downloading APKs from the latest release..."

curl -s https://api.github.com/repos/inCythe/UG-Auto_Setup/releases/latest | \
jq -r '.assets[] | select(.name | endswith(".apk")) | .url' | \
xargs -n 1 wget -O - 

echo "Installing APKs..."
pm install *.apk

echo "All APKs have been installed."