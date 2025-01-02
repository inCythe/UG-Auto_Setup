#!/bin/bash

DOWNLOAD_DIR="/storage/emulated/0/download"

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
        if curl -f -o "$DOWNLOAD_DIR/$apk" "https://raw.githubusercontent.com/inCythe/UG-Auto_Setup/main/apks/$apk"; then
            echo "$apk downloaded successfully to $DOWNLOAD_DIR."
        else
            echo "Failed to download $apk."
        fi
    done
}

download_from_release() {
    echo "Downloading Roblox.apk from the latest release..."
    response=$(curl -s https://api.github.com/repos/inCythe/UG-Auto_Setup/releases/latest)
    
    if echo "$response" | jq . >/dev/null 2>&1; then
        echo "Parsing response..."
        browser_download_url=$(echo "$response" | jq -r '.assets[] | select(.name == "Roblox.apk") | .browser_download_url')
        
        if [ -n "$browser_download_url" ]; then
            echo "Downloading from URL: $browser_download_url"
            if curl -f -L -o "$DOWNLOAD_DIR/Roblox.apk" "$browser_download_url"; then
                echo "Roblox.apk downloaded successfully to $DOWNLOAD_DIR."
            else
                echo "Failed to download Roblox.apk."
            fi
        else
            echo "Roblox.apk not found in the latest release."
        fi
    else
        echo "Failed to parse JSON response."
    fi
}

startup
download_from_repo
download_from_release

echo "Installing APKs..."
for apk in "$DOWNLOAD_DIR"/*.apk; do
    if [ -f "$apk" ]; then
        if termux-open "$apk"; then
            echo "$apk installation initiated."
        else
            echo "Failed to initiate installation for $apk."
        fi
    else
        echo "No APKs found in $DOWNLOAD_DIR."
    fi
done
