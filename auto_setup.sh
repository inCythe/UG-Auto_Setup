#!/bin/bash

setup_environment() {
    echo "Updating Termux packages..."
    yes | pkg update && yes | pkg upgrade

    yes | termux-setup-storage

    echo "Installing required tools..."
    yes | pkg install curl
}

download_file() {
    local APK_NAME=$1
    local APK_URL=$2

    echo "Using curl to download $APK_NAME..."
    curl -L -o "$APK_NAME" "$APK_URL"

    return $?
}

install_apk() {
    local APK_PATH=$1
    echo "Triggering installation for $APK_PATH..."
    
    am start -a android.intent.action.VIEW -d "$APK_PATH" -t "application/vnd.android.package-archive"

    return $?
}

declare -A APK_FILES=(
    ["Roblox.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.4.9/Roblox.apk"
    ["Android_ID_Changer.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Android_ID_Changer.apk"
    ["Control_Screen_Orientation.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Control_Screen_Orientation.apk"
    ["ZArchiver.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/ZArchiver.apk"
)

main() {
    echo "Setting up the environment..."
    setup_environment

    for APK_NAME in "${!APK_FILES[@]}"; do
        echo "Downloading $APK_NAME..."
        download_file "$APK_NAME" "${APK_FILES[$APK_NAME]}"

        if [[ $? -eq 0 ]]; then
            echo "Download successful: $APK_NAME"
            echo "Triggering installation for $APK_NAME..."
            install_apk "$APK_NAME"

        else
            echo "Failed to download $APK_NAME"
        fi
    done
}

main
