Gemini said
Done! Maine aapka custom "AUTO SSL" blocky ASCII art banner script mein set kar diya hai aur colors ko aur bhi zyada vibrant (bright) bana diya hai.

Ab jab aap script run karenge, toh yeh heavy professional look degi.

Bash
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

echo ""
read -p "Use Server [Local = y / Public = n] [y]: " SERVER
SERVER=${SERVER:-y}

# LOCAL SSL
if [ "$SERVER" = "y" ]; then

    NAME=$DOMAIN

    mkdir -p /etc/certs/$NAME
    cd /etc/certs/$NAME || exit

    openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
    -subj "/C=NA/ST=NA/L=NA/O=NA/CN=$DOMAIN" \
    -keyout privkey.pem -out fullchain.pem

    tee /etc/nginx/sites-available/$DOMAIN.conf > /dev/null <<EOF
server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/certs/$NAME/fullchain.pem;
    ssl_certificate_key /etc/certs/$NAME/privkey.pem;

    location / {
        proxy_pass http://$HOST;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
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
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

    ln -sf /etc/nginx/sites-available/$DOMAIN.conf /etc/nginx/sites-enabled/

    nginx -t && systemctl reload nginx

    certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect

fi


echo ""
echo "================================="
echo "          INSTALL COMPLETE       "
echo "================================="
echo "Domain : $DOMAIN"
echo "Host   : $HOST"

if [ "$SERVER" = "y" ]; then
echo "SSL    : Local Self-Signed"
else
echo "SSL    : Public Let's Encrypt"
fi

echo ""
echo "Site Ready 🚀"
