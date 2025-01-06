#!/bin/bash

clear

echo "Starting setup..."
echo "Updating Termux packages..."

yes | pkg update && yes | pkg upgrade

echo "Installing required tools..."

yes | pkg install curl
yes | termux-setup-storage

clear

echo "Installing APK files..."
echo ""

declare -A APK_FILES=(
    ["ZArchiver.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/ZArchiver.apk"
    ["Android_ID_Changer.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Android_ID_Changer.apk"
    ["Control_Screen_Orientation.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Control_Screen_Orientation.apk"
    ["Roblox.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox.apk"
    ["Roblox1.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox1.apk"
    ["Roblox2.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox2.apk"
    ["Roblox3.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox3.apk"
    ["Roblox4.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox4.apk"
)

DOWNLOAD_DIR="/storage/emulated/0/download"
mkdir -p "$DOWNLOAD_DIR"

for APK_NAME in "${!APK_FILES[@]}"; do
    APK_URL="${APK_FILES[$APK_NAME]}"

    echo "Downloading $APK_NAME..."
    curl -L -o "$DOWNLOAD_DIR/$APK_NAME" "$APK_URL"

    if [[ $? -eq 0 ]]; then
        echo "Download successful: $APK_NAME"
        echo ""

        echo "Installing $APK_NAME..."
        if command -v su >/dev/null 2>&1; then
            su -c "pm install -r $DOWNLOAD_DIR/$APK_NAME --install-reason 1"
        else
            am start -a android.intent.action.VIEW -d "file://$DOWNLOAD_DIR/$APK_NAME" -t "application/vnd.android.package-archive"
        fi
    else
        echo "Failed to download $APK_NAME. Skipping installation."
        echo ""
    fi

done

clear 

echo "Setup complete!"
