#!/bin/bash

download_from_repo() {
    echo "Downloading APKs from the repository..."
    for apk in "Android_ID_Changer.apk" "Control_Screen_Orientation.apk" "ZArchiver.apk"; do
        if curl -O https://raw.githubusercontent.com/inCythe/UG-Auto_Setup/main/apks/$apk; then
            echo "$apk downloaded successfully."
        else
            echo "Failed to download $apk."
        fi
    done
}

download_from_release() {
    echo "Downloading Executor from the latest release..."
    if curl -s https://api.github.com/repos/inCythe/UG-Auto_Setup/releases/latest/Roblox.apk; then
        echo "Executor downloaded successfully."
    else
        echo "Failed to Executor."
    fi
}

download_from_repo
download_from_release

echo "Installing APKs..."
if pm install *.apk; then
    echo "All APKs have been installed."
else
    echo "Failed to install some APKs."
fi