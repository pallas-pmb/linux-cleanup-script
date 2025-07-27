
#!/bin/bash

# EndeavourOS Cleanup Script with Dry Run Support

set -euo pipefail

GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=true
            ;;
    esac
done

run() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY RUN] Would run: $*${RESET}"
    else
        eval "$*"
    fi
}

echo -e "${GREEN}==> Starting cleanup for EndeavourOS...${RESET}"

# 1. Clean pacman cache (keep only the most recent versions)
echo -e "${YELLOW}➤ Cleaning pacman cache (removing older versions)...${RESET}"
run "sudo paccache -r"

# 2. Full cache cleanup (optional)
# run "sudo paccache -rk1 && sudo paccache -ruk0"

# 3. Remove orphaned packages
echo -e "${YELLOW}➤ Removing orphaned packages...${RESET}"
orphans=$(pacman -Qtdq || true)
if [[ -n "$orphans" ]]; then
    run "sudo pacman -Rns $orphans --noconfirm"
else
    echo "No orphaned packages found."
fi

# 4. Clean yay cache
if command -v yay &>/dev/null; then
    echo -e "${YELLOW}➤ Cleaning yay cache...${RESET}"
    run "yay -Sc --noconfirm"
fi

# 5. Limit journal logs
echo -e "${YELLOW}➤ Limiting journal logs to 100MB...${RESET}"
run "sudo journalctl --vacuum-size=100M"

# 6. Rotate systemd journal
echo -e "${YELLOW}➤ Rotating systemd journal...${RESET}"
run "sudo journalctl --rotate"

# 7. Delete old log files
echo -e "${YELLOW}➤ Deleting old log files...${RESET}"
run "sudo find /var/log -type f -name \"*.log.*\" -delete"

# 8. Clean temporary files
echo -e "${YELLOW}➤ Cleaning /tmp and user cache...${RESET}"
run "sudo rm -rf /tmp/*"
run "rm -rf ~/.cache/*"

# 9. Clean thumbnail cache
echo -e "${YELLOW}➤ Removing thumbnail cache...${RESET}"
run "rm -rf ~/.cache/thumbnails/*"

# 10. Clean Docker (if installed and running)
if command -v docker &>/dev/null; then
    if docker info &>/dev/null; then
        echo -e "${YELLOW}➤ Cleaning up Docker system...${RESET}"
        run "docker system prune -af --volumes"
    else
        echo -e "${YELLOW}➤ Docker is installed but not running — skipping...${RESET}"
    fi
fi

# 11. Clean Flatpak (if installed)
if command -v flatpak &>/dev/null; then
    echo -e "${YELLOW}➤ Removing unused Flatpak packages...${RESET}"
    run "flatpak uninstall --unused -y"
fi

echo -e "${GREEN}EndeavourOS cleanup complete.${RESET}"

set -euo pipefail

GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN}==> Starting cleanup for EndeavourOS...${RESET}"

# 1. Clean pacman cache (keep only the most recent versions)
echo -e "${YELLOW}➤ Cleaning pacman cache (removing older versions)...${RESET}"
sudo paccache -r

# 2. Full cache cleanup (optional)
# sudo paccache -rk1 && sudo paccache -ruk0

# 3. Remove orphaned packages
echo -e "${YELLOW}➤ Removing orphaned packages...${RESET}"
orphans=$(pacman -Qtdq || true)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns "$orphans" --noconfirm
else
    echo "No orphaned packages found."
fi

# 4. Clean yay cache
if command -v yay &>/dev/null; then
    echo -e "${YELLOW}➤ Cleaning yay cache...${RESET}"
    yay -Sc --noconfirm
fi

# 5. Limit journal logs
echo -e "${YELLOW}➤ Limiting journal logs to 100MB...${RESET}"
sudo journalctl --vacuum-size=100M

# 6. Rotate systemd journal
echo -e "${YELLOW}➤ Rotating systemd journal...${RESET}"
sudo journalctl --rotate

# 7. Delete old log files
echo -e "${YELLOW}➤ Deleting old log files...${RESET}"
sudo find /var/log -type f -name "*.log.*" -delete

# 8. Clean temporary files
echo -e "${YELLOW}➤ Cleaning /tmp and user cache...${RESET}"
sudo rm -rf /tmp/*
rm -rf ~/.cache/*

# 9. Clean thumbnail cache
echo -e "${YELLOW}➤ Removing thumbnail cache...${RESET}"
rm -rf ~/.cache/thumbnails/*

# 10. Clean Docker (if installed and running)
if command -v docker &>/dev/null; then
    if docker info &>/dev/null; then
        echo -e "${YELLOW}➤ Cleaning up Docker system...${RESET}"
        docker system prune -af --volumes
    else
        echo -e "${YELLOW}➤ Docker is installed but not running — skipping...${RESET}"
    fi
fi

# 11. Clean Flatpak (if installed)
if command -v flatpak &>/dev/null; then
    echo -e "${YELLOW}➤ Removing unused Flatpak packages...${RESET}"
    flatpak uninstall --unused -y
fi

echo -e "${GREEN}EndeavourOS cleanup complete.${RESET}"
