#!/bin/bash

# List of APKs to download (URLs)
declare -A APK_FILES=(
    ["Android_ID_Changer.apk"]="https://example.com/path/Android_ID_Changer.apk"
    ["Control_Screen_Orientation.apk"]="https://example.com/path/Control_Screen_Orientation.apk"
    ["Roblox_Arceus_X_NEO_1.4.9.apk"]="https://example.com/path/Roblox_Arceus_X_NEO_1.4.9.apk"
    ["ZArchiver.apk"]="https://example.com/path/ZArchiver.apk"
)

# Download and install each APK
for APK_NAME in "${!APK_FILES[@]}"; do
    echo "Downloading $APK_NAME..."
    wget -O "$APK_NAME" "${APK_FILES[$APK_NAME]}"
    
    if [[ $? -eq 0 ]]; then
        echo "Download successful: $APK_NAME"
        # Trigger installation (requires user interaction for confirmation)
        am start -a android.intent.action.VIEW -d "file://$(pwd)/$APK_NAME" -t "application/vnd.android.package-archive"
    else
        echo "Failed to download $APK_NAME"
    fi
done
