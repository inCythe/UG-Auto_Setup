#!/bin/bash

declare -A APK_FILES=(
    ["Roblox.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.4.9/Roblox.apk"
    ["Android_ID_Changer.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Android_ID_Changer.apk"
    ["Control_Screen_Orientation.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Control_Screen_Orientation.apk"
    ["ZArchiver.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/ZArchiver.apk"
)

for APK_NAME in "${!APK_FILES[@]}"; do
    echo "Downloading $APK_NAME..."
    wget -O "$APK_NAME" "${APK_FILES[$APK_NAME]}"
    
    if [[ $? -eq 0 ]]; then
        echo "Download successful: $APK_NAME"
        am start -a android.intent.action.VIEW -d "file://$(pwd)/$APK_NAME" -t "application/vnd.android.package-archive"
    else
        echo "Failed to download $APK_NAME"
    fi
done
