#!/bin/bash

# Configuration & Paths
CPU_FILE="/etc/cpu_name"

# Modern Color Palette (Cyberpunk/Neon)
CYAN='\033[38;5;51m'
PURPLE='\033[38;5;141m'
GRAY='\033[38;5;242m'
WHITE='\033[38;5;255m'
GREEN='\033[38;5;82m'
RED='\033[38;5;196m'
GOLD='\033[38;5;214m'
NC='\033[0m'

while true; do
    clear

    # System Logic
    HOST=$(hostname)
    IP=$(curl -s --max-time 2 ifconfig.me || echo "Offline")
    OS=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
    RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
    RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
    DISK=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    UP=$(uptime -p | sed 's/up //')
    
    CPU_REAL=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d ':' -f2 | xargs)
    [ -f "$CPU_FILE" ] && CPU=$(cat $CPU_FILE) || CPU=$CPU_REAL

    # --- HEADER ---
    echo -e "${PURPLE}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC}  ${CYAN}⚡ SYSTEM OVERLORD${NC} ${GRAY}v3.0${NC}             ${GRAY}$(date +"%H:%M:%S")${NC}  ${PURPLE}│${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"

    # --- STATUS SIDEBAR ---
    echo -e "  ${CYAN}SYSTEM STATUS${NC}"
    echo -e "  ${GRAY}├─ Host   :${NC} ${WHITE}$HOST${NC}"
    echo -e "  ${GRAY}├─ IP     :${NC} ${WHITE}$IP${NC}"
    echo -e "  ${GRAY}├─ OS     :${NC} ${WHITE}$OS${NC}"
    echo -e "  ${GRAY}├─ RAM    :${NC} ${WHITE}$RAM_USED / $RAM_TOTAL${NC}"
    echo -e "  ${GRAY}├─ Disk   :${NC} ${WHITE}$DISK${NC}"
    echo -e "  ${GRAY}└─ Uptime :${NC} ${WHITE}$UP${NC}"
    echo ""
    echo -e "  ${CYAN}VIRTUAL HARDWARE${NC}"
    echo -e "  ${GRAY}└─ CPU ID :${NC} ${GOLD}$CPU${NC}"
    echo -e "${GRAY}────────────────────────────────────────────────────────────${NC}"

    # --- MENU ---
    echo -e "  ${PURPLE}[1]${NC} ${WHITE}SSH Management${NC}"
    echo -e "  ${PURPLE}[2]${NC} ${WHITE}Network Hostname${NC}"
    echo -e "  ${PURPLE}[3]${NC} ${GOLD}CPU Spoofing (Full Menu)${NC}"
    echo -e "  ${PURPLE}[4]${NC} ${RED}Power: Reboot${NC}"
    echo -e "  ${PURPLE}[0]${NC} ${GRAY}Exit Terminal${NC}"
    echo ""
    echo -ne "  ${CYAN}»${NC} ${WHITE}Action:${NC} "
    read opt

    case $opt in
        1)
            clear
            echo -e "${CYAN}» SSH CONTROL${NC}"
            echo -e "1) Root ON  2) Root OFF  3) Change Pass  0) Back"
            read -p "Selection: " sshopt
            case $sshopt in
                1) sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config; systemctl restart sshd; echo "Enabled" ;;
                2) sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config; systemctl restart sshd; echo "Disabled" ;;
                3) passwd root ;;
            esac
            sleep 1
            ;;
        2)
            clear
            echo -e "${CYAN}» CHANGE HOSTNAME${NC}"
            read -p "New Name: " newhost
            if [[ -n "$newhost" ]]; then
                hostnamectl set-hostname "$newhost"
                echo "Hostname updated."
            fi
            sleep 1
            ;;
        3)
            while true; do
                clear
                echo -e "${GOLD}┌──────────────────────────────────────────────────────────┐${NC}"
                echo -e "${GOLD}│${NC}              ${WHITE}SELECT CPU ARCHITECTURE${NC}              ${GOLD}│${NC}"
                echo -e "${GOLD}└──────────────────────────────────────────────────────────┘${NC}"
                echo -e "  ${CYAN}[A] AMD RYZEN${NC}       ${PURPLE}[I] INTEL CORE${NC}"
                echo -e "  ${GREEN}[S] SERVER/EPYC${NC}     ${WHITE}[M] APPLE SILICON${NC}"
                echo -e "  ${GOLD}[C] CUSTOM NAME${NC}     ${RED}[X] BACK${NC}"
                echo ""
                read -n1 -p "  Select Category: " catopt
                echo ""

                case $catopt in
                    [Aa])
                        echo -e "\n1) Ryzen 9 7950X  2) Ryzen 9 5950X  3) Ryzen 7 5800X"
                        read -p "Choice: " amopt
                        case $amopt in
                            1) echo "AMD Ryzen 9 7950X 16-Core Processor" > $CPU_FILE ;;
                            2) echo "AMD Ryzen 9 5950X 16-Core Processor" > $CPU_FILE ;;
                            3) echo "AMD Ryzen 7 5800X 8-Core Processor" > $CPU_FILE ;;
                        esac
                        break ;;
                    [Ii])
                        echo -e "\n1) Core i9-14900K  2) Core i9-13900K  3) Core i7-12700K"
                        read -p "Choice: " inopt
                        case $inopt in
                            1) echo "14th Gen Intel(R) Core(TM) i9-14900K" > $CPU_FILE ;;
                            2) echo "13th Gen Intel(R) Core(TM) i9-13900K" > $CPU_FILE ;;
                            3) echo "12th Gen Intel(R) Core(TM) i7-12700K" > $CPU_FILE ;;
                        esac
                        break ;;
                    [Ss])
                        echo -e "\n1) AMD EPYC 9654 (96C)  2) Intel Xeon Platinum 8480+  3) Ampere Altra (ARM)"
                        read -p "Choice: " svopt
                        case $svopt in
                            1) echo "AMD EPYC 9654 96-Core Processor" > $CPU_FILE ;;
                            2) echo "Intel(R) Xeon(R) Platinum 8480+" > $CPU_FILE ;;
                            3) echo "Ampere(R) Altra(R) Processor" > $CPU_FILE ;;
                        esac
                        break ;;
                    [Mm])
                        echo -e "\n1) Apple M3 Max  2) Apple M2 Ultra  3) Apple M1 Pro"
                        read -p "Choice: " mopt
                        case $mopt in
                            1) echo "Apple M3 Max" > $CPU_FILE ;;
                            2) echo "Apple M2 Ultra" > $CPU_FILE ;;
                            3) echo "Apple M1 Pro" > $CPU_FILE ;;
                        esac
                        break ;;
                    [Cc])
                        read -p "Enter Custom CPU String: " cname
                        echo "$cname" > $CPU_FILE
                        break ;;
                    [Xx]) break ;;
                esac
            done
            echo -e "${GREEN}CPU Identity Spoofed!${NC}"
            sleep 1
            ;;
        4)
            echo -ne "${RED}Reboot System? (y/N): ${NC}"
            read confirm
            [[ "$confirm" == "y" ]] && reboot
            ;;
        0)
            echo -e "\n${CYAN}Exiting...${NC}"
            exit 0
            ;;
    esac
done
