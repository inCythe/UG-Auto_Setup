#!/bin/bash

DOWNLOAD_DIR="/storage/emulated/0/download"
GOFILE_LINK="https://gofile.io/d/VcMy16"

startup() {
    if ! command -v jq &> /dev/null; then
        echo "Checking Please Wait..."
        pkg install jq -y
    else
        echo "Starting Setup"
    fi
}

download_from_gofile() {
    echo "Downloading APKs from Gofile..."
    
    if curl -L -o "$DOWNLOAD_DIR/Android_ID_Changer.apk" "$GOFILE_LINK/Android_ID_Changer.apk"; then
        echo "Android_ID_Changer.apk downloaded successfully."
    else
        echo "Failed to download Android_ID_Changer.apk."
    fi

    if curl -L -o "$DOWNLOAD_DIR/Control_Screen_Orientation.apk" "$GOFILE_LINK/Control_Screen_Orientation.apk"; then
        echo "Control_Screen_Orientation.apk downloaded successfully."
    else
        echo "Failed to download Control_Screen_Orientation.apk."
    fi

    if curl -L -o "$DOWNLOAD_DIR/ZArchiver.apk" "$GOFILE_LINK/ZArchiver.apk"; then
        echo "ZArchiver.apk downloaded successfully."
    else
        echo "Failed to download ZArchiver.apk."
    fi

    if curl -L -o "$DOWNLOAD_DIR/Roblox.apk" "$GOFILE_LINK/Roblox.apk"; then
        echo "Roblox.apk downloaded successfully."
    else
        echo "Failed to download Roblox.apk."
    fi
}

startup
download_from_gofile

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
