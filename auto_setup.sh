#!/bin/bash

startup() {
    if ! command -v jq &> /dev/null; then
        echo "Checking Please Wait..."
        pkg install jq -y
    else
        echo "Starting Setup"
    fi
}

download_from_repo() {
    echo "Downloading APKs from the repository..."
    for apk in "Android_ID_Changer.apk" "Control_Screen_Orientation.apk" "ZArchiver.apk"; do
        curl -O https://raw.githubusercontent.com/inCythe/UG-Auto_Setup/main/apks/$apk
    done
}

download_from_release() {
    echo "Downloading APKs from the latest release..."
    curl -s https://api.github.com/repos/inCythe/UG-Auto_Setup/releases/latest | \
    jq -r '.assets[] | select(.name | endswith(".apk")) | .url' | \
    xargs -n 1 curl -LO
}

startup
download_from_repo
download_from_release

echo "Installing APKs..."
if pm install *.apk; then
    echo "All APKs have been installed."
else
    echo "Failed to install some APKs."
fi