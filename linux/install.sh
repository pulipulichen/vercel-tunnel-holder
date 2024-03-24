#!/bin/bash

# Check if a parameter is provided
if [ $# -eq 0 ]; then
    echo "No parameter provided. Exiting."
    exit 1
fi

rm *.sh

# ============

if [ -f "url.txt" ]; then
  mv url.txt url.tmp
fi

if [ -f "cloudflare-url.txt" ]; then
  mv cloudflare-url.txt cloudflare-url.tmp
fi

# ============

rm *.txt

# ============

if [ -f "url.tmp" ]; then
  mv url.tmp url.txt
fi

if [ -f "cloudflare-url.tmp" ]; then
  mv cloudflare-url.tmp cloudflare-url.txt
fi

# ============

cd "$(dirname "$0")"

# Access the provided parameter
echo $1 > target.txt

# ==========

if ! command -v curl &> /dev/null; then
  apt-get update
  apt-get install -y curl wget
fi

# =================================================================

if ! command -v cloudflared &> /dev/null; then
  wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
  dpkg -i cloudflared-linux-amd64.deb
  rm -rf cloudflared-linux-amd64.deb
fi

# =================================================================

wget https://pulipulichen.github.io/vercel-tunnel-holder/linux/startup.sh
wget https://pulipulichen.github.io/vercel-tunnel-holder/linux/random_sleep_startup.sh
wget https://pulipulichen.github.io/vercel-tunnel-holder/linux/setup_url.sh
wget https://pulipulichen.github.io/vercel-tunnel-holder/linux/api.txt

chmod +x *.sh

# =================================================================

# Function to check and append command to /etc/crontab if not present
check_and_append_crontab() {
    local command_to_check="$1"
    if ! grep -q "$command_to_check" /etc/crontab; then
        echo "$command_to_check" | sudo tee -a /etc/crontab > /dev/null
        echo "Command appended to /etc/crontab"
    else
        echo "Command already exists in /etc/crontab"
    fi
}

check_and_append_crontab "@reboot root $(pwd)/startup.sh"

#if ! grep -q "random_sleep_startup.sh" /etc/crontab; then
check_and_append_crontab "0 */3 * * * root $(pwd)/random_sleep_startup.sh"
#fi

# =================================================================

# Get the current timezone
current_timezone=$(timedatectl | grep "Time zone" | awk '{print $3}')

# Check if the current timezone is not Asia/Taipei
if [ "$current_timezone" != "Asia/Taipei" ]; then
  timedatectl set-timezone Asia/Taipei
  reboot
else
  ./startup.sh
fi