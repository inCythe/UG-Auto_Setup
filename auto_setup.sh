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
echo ""

yes | pkg update && yes | pkg upgrade

clear
print_banner

print_status "Installing required tools..."
echo ""

yes | pkg install curl
yes | termux-setup-storage

clear
print_banner

print_status "Installing APK files..."
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
    clear
    print_banner
    
    echo -e "\033[1;32m[+] Downloading $APK_NAME...\033[0m"
    echo ""
    
    curl -L -o "$DOWNLOAD_DIR/$APK_NAME" "$APK_URL"
    if [[ $? -eq 0 ]]; then
        clear
        print_banner

        echo -e "\033[1;32m[✓] Download successful: $APK_NAME\033[0m"
        echo ""

        clear
        print_banner

        echo -e "\033[1;33m[*] Installing $APK_NAME...\033[0m"
        echo ""
        
        if command -v su >/dev/null 2>&1; then
            su -c "pm install -r $DOWNLOAD_DIR/$APK_NAME"
        else
            am start -a android.intent.action.VIEW -d "file://$DOWNLOAD_DIR/$APK_NAME" -t "application/vnd.android.package-archive"
        fi
    else
        clear
        print_banner

        echo -e "\033[1;31m[✗] Failed to download $APK_NAME. Skipping installation.\033[0m"
        echo ""
    fi
done

clear
print_banner
echo -e "\033[1;32m[✓] Setup complete!\033[0m"