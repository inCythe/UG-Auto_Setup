#!/bin/bash

setup_environment() {
    echo "Updating Termux packages..."
    yes | pkg update && yes | pkg upgrade

    echo "Installing required tools..."
    yes | pkg install curl
    
    yes | termux-setup-storage
}

download_file() {
    local APK_NAME=$1
    local APK_URL=$2
    local DOWNLOAD_DIR="/storage/emulated/0/download"

    mkdir -p "$DOWNLOAD_DIR"

    echo "Using curl to download $APK_NAME..."
    curl -L -o "$DOWNLOAD_DIR/$APK_NAME" "$APK_URL"

    return $?
}

install_apk() {
    local APK_PATH=$1
    
    echo "Installing $APK_PATH..."
    if command -v su >/dev/null 2>&1; then
        su -c "pm install -r $APK_PATH"
    else
        am start -a android.intent.action.VIEW -d "file://$APK_PATH" -t "application/vnd.android.package-archive"
    fi
}

declare -A APK_FILES=(
    ["Roblox.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox.apk"
    ["Roblox1.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox1.apk"
    ["Roblox2.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox2.apk"
    ["Roblox3.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox3.apk"
    ["Roblox4.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox4.apk"
    ["Android_ID_Changer.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Android_ID_Changer.apk"
    ["Control_Screen_Orientation.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Control_Screen_Orientation.apk"
    ["ZArchiver.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/ZArchiver.apk"
)

main() {
    echo "Setting up the environment..."
    setup_environment

    local DOWNLOAD_DIR="/storage/emulated/0/download"
    
    for APK_NAME in "${!APK_FILES[@]}"; do
        echo "Downloading $APK_NAME..."
        download_file "$APK_NAME" "${APK_FILES[$APK_NAME]}"

        if [[ $? -eq 0 ]]; then
            echo "Download successful: $APK_NAME"
            install_apk "$DOWNLOAD_DIR/$APK_NAME"
        else
            echo "Failed to download $APK_NAME"
        fi
    done
    
    echo "Setup complete! Please check your device for any installation prompts."
}

main