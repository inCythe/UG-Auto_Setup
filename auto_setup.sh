#!/bin/bash

print_banner() {
    echo -e "\033[1;36m"
    echo "╔════════════════════════════════╗"
    echo "║           Auto Setup           ║"
    echo "╚════════════════════════════════╝"
    echo -e "\033[0m"
}

print_status() {
    echo -e "\033[1;33m[*] $1\033[0m"
}

clear
print_banner

print_status "Updating Termux packages..."
yes | pkg update && yes | pkg upgrade

print_status "Installing required tools..."
yes | pkg install curl
yes | termux-setup-storage

clear
print_banner
print_status "Installing APK files..."
echo ""

declare -A APK_FILES=(
    ["1_ZArchiver.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/ZArchiver.apk"
    ["2_Android_ID_Changer.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Android_ID_Changer.apk"
    ["3_Control_Screen_Orientation.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Control_Screen_Orientation.apk"
    ["4_Roblox.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox.apk"
    ["5_Roblox1.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox1.apk"
    ["6_Roblox2.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox2.apk"
    ["7_Roblox3.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox3.apk"
    ["8_Roblox4.apk"]="https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox4.apk"
)

DOWNLOAD_DIR="/storage/emulated/0/download"
mkdir -p "$DOWNLOAD_DIR"

for APK_NAME in $(echo "${!APK_FILES[@]}" | tr ' ' '\n' | sort); do
    CLEAN_NAME="${APK_NAME:2}"
    APK_URL="${APK_FILES[$APK_NAME]}"

    clear
    print_banner
    echo ""
    
    echo -e "\033[1;32m[+] Downloading $CLEAN_NAME...\033[0m"
    echo ""
    
    curl -L -o "$DOWNLOAD_DIR/$CLEAN_NAME" "$APK_URL"

    if [[ $? -eq 0 ]]; then
        echo ""
        echo -e "\033[1;32m[✓] Download successful: $CLEAN_NAME\033[0m"
        echo ""
        echo -e "\033[1;33m[*] Installing $CLEAN_NAME...\033[0m"
        echo ""
        
        if command -v su >/dev/null 2>&1; then
            su -c "pm install -r $DOWNLOAD_DIR/$CLEAN_NAME"
        else
            am start -a android.intent.action.VIEW -d "file://$DOWNLOAD_DIR/$CLEAN_NAME" -t "application/vnd.android.package-archive"
        fi
    else
        echo -e "\033[1;31m[✗] Failed to download $CLEAN_NAME. Skipping installation.\033[0m"
        echo ""
    fi
done

clear
print_banner
echo -e "\033[1;32m[✓] Setup complete!\033[0m"