#!/bin/bash

# =============================================================================
# Arch Linux Rice Installation Script
# Based on NeKoRoSYS-s-Arch-Linux-Rice
# =============================================================================

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting installation...${NC}"

# 1. Replace all hardcoded usernames
# The repo contains paths like /home/nekorosys/ in Waybar, Hyprlock, and scripts.
echo -e "${BLUE}Updating paths for user: $USER...${NC}"
find . -type f -exec sed -i "s|/home/nekorosys|/home/$USER|g" {} +

# 2. Install System Dependencies
# Uses the provided pkglist.txt
if [ -f "pkglist.txt" ]; then
    echo -e "${BLUE}Installing packages from pkglist.txt...${NC}"
    sudo pacman -S --needed $(cat pkglist.txt)
else
    echo -e "${RED}Error: pkglist.txt not found!${NC}"
    exit 1
fi

# 3. Install Python Dependencies for Pywal
# Required by README.md for haishoku and colorthief
echo -e "${BLUE}Installing Pywal backend dependencies...${NC}"
pip install haishoku colorthief --break-system-packages 2>/dev/null || pip install haishoku colorthief

# 4. Create necessary directory structure
echo -e "${BLUE}Creating directory structure...${NC}"
mkdir -p ~/Downloads
mkdir -p ~/.config

# 5. Copy everything to the Home directory
# This copies the .config folder (hypr, waybar, mako, wofi) and the Downloads folder
echo -e "${BLUE}Deploying configuration files and wallpapers...${NC}"
cp -rv .config ~/
cp -rv Downloads ~/

# 6. Set executable permissions for scripts
# Ensures wallpaper and lock scripts can run
echo -e "${BLUE}Setting script permissions...${NC}"
chmod +x ~/.config/hypr/scripts/*.sh 2>/dev/null
chmod +x ~/.config/hypr/scripts/wallpapers/*.sh 2>/dev/null

# 7. Final Instructions
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Log out and log into Hyprland."
echo -e "2. Once inside, run the wallpaper script to generate your first color scheme:"
echo -e "   ${GREEN}~/.config/hypr/scripts/wallpapers/set-random.sh${NC}"