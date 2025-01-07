#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║                Auto Setup                ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${RESET}"
}

print_status() {
    echo -e "${YELLOW}[*] $1${RESET}\n"
}

print_success() {
    echo -e "${GREEN}[✓] $1${RESET}\n"
}

print_error() {
    echo -e "${RED}[✗] $1${RESET}\n"
}

print_banner
print_status "Initializing package updates..."
yes | pkg update && yes | pkg upgrade

print_banner
print_status "Setting up environment..."
yes | pkg install curl
yes | termux-setup-storage

DOWNLOAD_DIR="/storage/emulated/0/download"
mkdir -p "$DOWNLOAD_DIR"

declare -a APK_FILES=(
    "UG_Cloner.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/UG_Cloner.apk"
    "ZArchiver.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/ZArchiver.apk"
    "Android_ID_Changer.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Android_ID_Changer.apk"
    "Control_Screen_Orientation.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/1.0/Control_Screen_Orientation.apk"
    "Roblox.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox.apk"
    "Roblox1.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox1.apk"
    "Roblox2.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox2.apk"
    "Roblox3.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox3.apk"
    "Roblox4.apk|https://github.com/inCythe/UG-Auto_Setup/releases/download/Executor/Roblox4.apk"
)

for APK in "${APK_FILES[@]}"; do
    APK_NAME="${APK%%|*}"
    APK_URL="${APK##*|}"
    
    print_banner
    print_status "Downloading: $APK_NAME"
    
    if curl -L -o "$DOWNLOAD_DIR/$APK_NAME" "$APK_URL"; then
        print_banner
        print_success "Download complete: $APK_NAME"
        sleep 1

        print_banner
        print_status "Installing: $APK_NAME"
        
        if command -v su >/dev/null 2>&1; then
            su -c "pm install -r $DOWNLOAD_DIR/$APK_NAME"
        else
            am start -a android.intent.action.VIEW \
                     -d "file://$DOWNLOAD_DIR/$APK_NAME" \
                     -t "application/vnd.android.package-archive"
        fi
        print_banner
        print_success "Installation complete: $APK_NAME"
        sleep 2
    else
        print_banner
        print_error "Failed to download: $APK_NAME"
        sleep 3
    fi
done

print_banner
print_success "Setup completed successfully!"
sleep 4