#!/bin/bash

# ==========================================
# 🎨 UI CONFIGURATION & COLORS
# ==========================================
# Regular Colors
R="\e[31m"; G="\e[32m"; Y="\e[33m"
B="\e[34m"; M="\e[35m"; C="\e[36m"
W="\e[97m"; N="\e[0m"

# Bold & Effects
BR="\e[1;31m"; BG="\e[1;32m"; BY="\e[1;33m"
BB="\e[1;34m"; BM="\e[1;35m"; BC="\e[1;36m"
BW="\e[1;97m"
UL="\e[4m"
BLINK="\e[5m"

# Backgrounds
BG_BLUE="\e[44m"
BG_RED="\e[41m"

# ==========================================
# 🛠️ HELPER FUNCTIONS
# ==========================================

# Trap Ctrl+C
trap 'echo -e "\n${R} [!] Force exit detected.${N}"; exit 1' SIGINT

# Centered Text function
print_center() {
    local text="$1"
    local width=60
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}

# The Header
header() {
  clear
  echo -e "${BC}"
  echo " ╔══════════════════════════════════════════════════════════╗"
  echo " ║                                                          ║"
  printf " ║${BW}%-58s${BC}║\n" "$(print_center "⚡ BLUEPRINT CONTROL HUB ⚡")"
  echo " ║                                                          ║"
  printf " ║${B}%-58s${BC}║\n" "$(print_center "Minimal • Clean • High Performance")"
  echo " ║                                                          ║"
  echo " ╚══════════════════════════════════════════════════════════╝"
  echo -e "${N}"
  
  # System Info (Optional visual touch)
  echo -e " ${B}User:${N} $(whoami)  ${B}Host:${N} $(hostname)  ${B}Date:${N} $(date +'%H:%M')"
  echo -e "${C} ──────────────────────────────────────────────────────────${N}"
}

# Pause with style
pause() {
  echo
  echo -e "${B} ──────────────────────────────────────────────────────────${N}"
  read -rp " ↩️  Press Enter to return to main menu..."
}

# ==========================================
# 📋 ACTIONS
# ==========================================
CD='cd /var/www/pterodactyl'
RE='yes | blueprint -r'
IN='yes | blueprint -i'

# ==========================================
# 🖥️ MAIN MENU
# ==========================================
show_menu() {
  header
  echo -e "${BW} SELECT AN OPTION:${N}\n"

  echo -e "  ${BG}[ 1 ]${N} Nebula"
  echo -e "  ${BY}[ 2 ]${N}  Install Blueprint 2 (Fresh Rebuild)"
  echo -e "  ${BM}[ 3 ]${N}  Auto Fix / Repair"
  echo -e "  ${BM}[ 4 ]${N}  hyperv1"
  echo -e "  ${BG}[ 5 ]${N}    Install Blueprint 1"
  echo -e "  ${BY}[ 6 ]${N}    Install Blueprint 2 (Fresh Rebuild)"
  echo -e "  ${BM}[ 7 ]${N}     Auto Fix / Repair"
  echo -e "  ${BM}[ 8 ]${N}     hyperv1"
  echo -e "  ${BG}[ 9 ]${N}    Install Blueprint 1"
  echo -e "  ${BY}[ 10 ]${N}    Install Blueprint 2 (Fresh Rebuild)"
  echo -e "  ${BM}[ 11 ]${N}     Auto Fix / Repair"
  echo -e "  ${BM}[ 12 ]${N}     hyperv1"
  echo -e "  ${BG}[ 13 ]${N}    Install Blueprint 1"
  echo -e "  ${BY}[ 14 ]${N}    Install Blueprint 2 (Fresh Rebuild)"
  echo -e "  ${BM}[ 15 ]${N}     Auto Fix / Repair"
  echo -e "  ${BM}[ 16 ]${N}     hyperv1"
  echo -e ""
  echo -e "  ${BR}[ 0 ]${N}  ❌  Exit Panel"
  
  echo -e "\n${C} ──────────────────────────────────────────────────────────${N}"
}

# ==========================================
# 🔄 EXECUTION LOOP
# ==========================================
while true; do
  show_menu
  read -p " 👉 Enter your choice: " opt
  case $opt in
    1)
        echo "Option 1"
        clear
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 1..." ;;
            2) echo "Uninstalling Option 1..." ;;
        esac
        ;;
    2)
        echo "Option 2"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 2..." ;;
            2) echo "Uninstalling Option 2..." ;;
        esac
        ;;
    3)
        echo "Option 3"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 3..." ;;
            2) echo "Uninstalling Option 3..." ;;
        esac
        ;;
    4)
        echo "Option 4"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 4..." ;;
            2) echo "Uninstalling Option 4..." ;;
        esac
        ;;
    5)
        echo "Option 5"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 5..." ;;
            2) echo "Uninstalling Option 5..." ;;
        esac
        ;;
    6)
        echo "Option 6"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 6..." ;;
            2) echo "Uninstalling Option 6..." ;;
        esac
        ;;
    7)
        echo "Option 7"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 7..." ;;
            2) echo "Uninstalling Option 7..." ;;
        esac
        ;;
    8)
        echo "Option 8"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 8..." ;;
            2) echo "Uninstalling Option 8..." ;;
        esac
        ;;
    9)
        echo "Option 9"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 9..." ;;
            2) echo "Uninstalling Option 9..." ;;
        esac
        ;;
    10)
        echo "Option 10"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 10..." ;;
            2) echo "Uninstalling Option 10..." ;;
        esac
        ;;
    11)
        echo "Option 11"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 11..." ;;
            2) echo "Uninstalling Option 11..." ;;
        esac
        ;;
    12)
        echo "Option 12"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 12..." ;;
            2) echo "Uninstalling Option 12..." ;;
        esac
        ;;
    13)
        echo "Option 13"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 13..." ;;
            2) echo "Uninstalling Option 13..." ;;
        esac
        ;;
    14)
        echo "Option 14"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 14..." ;;
            2) echo "Uninstalling Option 14..." ;;
        esac
        ;;
    15)
        echo "Option 15"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 15..." ;;
            2) echo "Uninstalling Option 15..." ;;
        esac
        ;;
    16)
        echo "Option 16"
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 16..." ;;
            2) echo "Uninstalling Option 16..." ;;
        esac
        ;;
    17)
        echo "Option 17"
        clear
        echo "1) Install"
        echo "2) Uninstall"
        read choice
        case $choice in
            1) echo "Installing Option 17..." ;;
            2) echo "Uninstalling Option 17..." ;;
        esac
        ;;


    0) 
       echo -e "\n${M} 👋 Exiting... Panel shant ho gaya.${N}"
       sleep 0.5
       clear
       exit 
       ;;
    *) 
       echo -e "\n${R} ❌ Invalid Option! Please try again.${N}"
       sleep 1
       ;;
  esac
done
