#!/bin/bash

# --- Colors and Styling ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

while true; do
    clear
    
    # Check installation status
    if command -v blueprint >/dev/null 2>&1; then
        STATUS="${GREEN}${BOLD}INSTALLED ✅${NC}"
        installed=true
    else
        STATUS="${RED}${BOLD}NOT INSTALLED ❌${NC}"
        installed=false
    fi

    # --- Header ---
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${BOLD}          BLUEPRINT MANAGER v1.0          ${NC}"
    echo -e "${CYAN}==========================================${NC}"
    echo -e " Status: $STATUS"
    echo -e "${CYAN}------------------------------------------${NC}"

    if [ "$installed" = false ]; then
        echo -e " ${YELLOW}1)${NC} Install"
        echo -e " ${YELLOW}0)${NC} Exit"
        echo ""
        echo -ne "${BOLD}Select an option: ${NC}"
        read choice

        case $choice in
            1)
                echo -e "\n${BLUE}🚀 Starting Installation...${NC}"
                rm -f /etc/apt/keyrings/nodesource.gpg 2>/dev/null
                bash <(curl -s https://raw.githubusercontent.com/nobita329/hub/refs/heads/main/Codinghub/thames/install.sh)
                ;;
            0) exit ;;
            *) echo -e "${RED}Invalid option!${NC}" ; sleep 1 ;;
        esac

    else
        echo -e " ${YELLOW}1)${NC} Reinstall"
        echo -e " ${YELLOW}2)${NC} Update"
        echo -e " ${YELLOW}3)${NC} Info"
        echo -e " ${YELLOW}4)${NC} Version"
        echo -e " ${YELLOW}5)${NC} Uninstall"
        echo -e " ${YELLOW}0)${NC} Exit"
        echo -e "${CYAN}------------------------------------------${NC}"
        echo -ne "${BOLD}Select an option: ${NC}"
        read choice

        case $choice in
            1)
                echo -e "\n${BLUE}🔄 Reinstalling...${NC}"
                yes | blueprint -rerun-install
                ;;
            2)
                echo -e "\n${BLUE}🆙 Checking for updates...${NC}"
                yes | blueprint -upgrade
                ;;
            3)
                echo -e "\n${CYAN}📄 Blueprint Info:${NC}"
                blueprint -info
                ;;
            4)
                echo -e "\n${CYAN}🔢 Current Version:${NC}"
                blueprint -version
                ;;
            5)
                echo -e "\n${RED}⚠️  Uninstalling Blueprint...${NC}"
                path=$(which blueprint)
                if [ -n "$path" ]; then
                    rm -f "$path"                    
                    rm -f $(which blueprint)
                    rm -rf ~/.blueprint ~/.config/blueprint
                    rm -rf /var/www/pterodactyl/.blueprint
                    echo -e "${GREEN}Blueprint removed successfully ✅${NC}"
                else
                    echo -e "${RED}Blueprint already not installed ❌${NC}"
                fi
                ;;
            0) exit ;;
            *) echo -e "${RED}Invalid option!${NC}" ; sleep 1 ;;
        esac
    fi

    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read dummy
done
