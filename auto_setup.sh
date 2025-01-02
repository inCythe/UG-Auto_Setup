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
        if curl -O https://raw.githubusercontent.com/inCythe/UG-Auto_Setup/main/apks/$apk; then
            echo "$apk downloaded successfully."
        else
            echo "Failed to download $apk."
        fi
    done
}

download_from_release() {
    echo "Downloading Roblox.apk from the latest release..."
    response=$(curl -s https://api.github.com/repos/inCythe/UG-Auto_Setup/releases/latest)
    
    echo "Response from GitHub API:"
    echo "$response"

    if echo "$response" | jq . >/dev/null 2>&1; then
        echo "Parsing response..."
        download_url=$(echo "$response" | jq -r '.assets[] | select(.name == "Roblox.apk") | .url')
        
        if [ -n "$download_url" ]; then
            curl -LO "$download_url" && echo "Roblox.apk downloaded successfully." || echo "Failed to download Roblox.apk."
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
for apk in *.apk; do
    if termux-open "$apk"; then
        echo "$apk installation initiated."
    else
        echo "Failed to initiate installation for $apk."
    fi
done