
#!/bin/bash

# --- Color Palette ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# --- Custom AUTO SSL Banner ---
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "    █████████   █████  █████ ███████████     ███████         █████████   █████████  █████      "
    echo "   ███░░░░░███ ░░███  ░░███ ░█░░░███░░░█   ███░░░░░███      ███░░░░░███ ███░░░░░███░░███      "
    echo "  ░███    ░███  ░███   ░███ ░   ░███  ░   ███     ░░███    ░███     ░░░ ░███     ░░░  ░███      "
    echo "  ░███████████  ░███   ░███     ░███     ░███      ░███    ░░█████████ ░░█████████  ░███      "
    echo "  ░███░░░░░███  ░███   ░███     ░███     ░███      ░███     ░░░░░░░░███ ░░░░░░░░███ ░███      "
    echo "  ░███    ░███  ░███   ░███     ░███     ░░███     ███      ███    ░███ ███    ░███ ░███      █"
    echo "  █████   █████ ░░████████      █████     ░░░███████░       ░░█████████ ░░█████████  ███████████"
    echo " ░░░░░   ░░░░░   ░░░░░░░░      ░░░░░        ░░░░░░░         ░░░░░░░░░   ░░░░░░░░░   ░░░░░░░░░░░ "
    echo -e "${NC}"
    echo -e "${YELLOW}========================================================================================${NC}"
    echo -e "             ${WHITE}PREMIUM REVERSE PROXY & AUTOMATED SSL INSTALLER${NC}"
    echo -e "${YELLOW}========================================================================================${NC}"
    echo ""
}

# Dependency Check
if ! command -v whiptail &> /dev/null; then
    echo -e "${YELLOW}Updating and installing UI components...${NC}"
    apt update && apt install -y whiptail nginx certbot python3-certbot-nginx openssl > /dev/null 2>&1
fi

# Root check
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}CRITICAL ERROR: Please run this script as root (sudo).${NC}"
  exit 1
fi

show_banner
# inputs
read -p "Enter Domain [panel.example.com]: " DOMAIN
DOMAIN=${DOMAIN:-panel.example.com}

read -p "Enter Host [127.0.0.1:3000]: " HOST
HOST=${HOST:-127.0.0.1:3000}
read -p "Enter Domain [panel]: " NAME
NAME=${NAME:-panel}
echo ""
read -p "Use Server [Local = y / Public = n] [y]: " SERVER
SERVER=${SERVER:-y}

# LOCAL SSL
if [ "$SERVER" = "y" ]; then

    NAME=$DOMAIN

    mkdir -p /etc/certs/$NAME
    cd /etc/certs/$NAME || exit
    openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
-subj "/C=NA/ST=NA/L=NA/O=NA/CN=Generic SSL Certificate" \
-keyout privkey.pem -out fullchain.pem

    tee /etc/nginx/sites-available/$DOMAIN.conf > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/certs/$NAME/fullchain.pem;
    ssl_certificate_key /etc/certs/$NAME/privkey.pem;

    location / {
        proxy_pass http://$HOST;
        proxy_http_version 1.1;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}
EOF

    ln -sf /etc/nginx/sites-available/$DOMAIN.conf /etc/nginx/sites-enabled/

    nginx -t && systemctl reload nginx

fi


# PUBLIC SSL
if [ "$SERVER" = "n" ]; then

    EMAIL="admin@$DOMAIN"

    tee /etc/nginx/sites-available/$DOMAIN.conf > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://$HOST;
        proxy_http_version 1.1;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

    ln -sf /etc/nginx/sites-available/$DOMAIN.conf /etc/nginx/sites-enabled/

    nginx -t && systemctl reload nginx

    certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect

fi
clear

# --- End of Script Section ---

show_banner
echo -e "${CYAN}======================================================${NC}"
echo -e "${GREEN}                🚀 INSTALLATION COMPLETE               ${NC}"
echo -e "${CYAN}======================================================${NC}"
echo ""
# Displaying Key Information in a Clean Layout
echo -e "${WHITE}  ➤  Domain Name : ${YELLOW}$DOMAIN${NC}"
echo -e "${WHITE}  ➤  Backend Host: ${YELLOW}$HOST${NC}"
# Dynamic SSL Status Output
if [ "$SERVER" = "y" ]; then
    echo -e "${WHITE}  ➤  SSL Status  : ${CYAN}Local Self-Signed${NC}"
else
    echo -e "${WHITE}  ➤  SSL Status  : ${GREEN}Public Let's Encrypt (Active)${NC}"
fi
echo ""
echo -e "${CYAN}======================================================${NC}"
echo -e "${PURPLE}       Your site is ready to use! Enjoy! 🔥${NC}"
echo -e "${CYAN}======================================================${NC}"
echo ""

