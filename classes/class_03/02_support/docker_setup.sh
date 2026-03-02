#!/bin/bash

# Exit immediately if a command exits with a non-zero status (unless handled)
set -e

################### Argument Parsing (using getopt) ###################
OPTIONS=$(getopt -o h --long help,os: -- "$@")
if [ $? -ne 0 ]; then
    echo "Argument parsing failed." >&2
    exit 1
fi

eval set -- "$OPTIONS"

OVERRIDE_OS=""
OVERRIDE_CODENAME=""
SHOW_HELP=0

while true; do
    case "$1" in
        --os)
            OS_PARAM="${2%/*}"
            CODENAME_PARAM="${2#*/}"
            OVERRIDE_OS="$OS_PARAM"
            OVERRIDE_CODENAME="$CODENAME_PARAM"
            shift 2
            ;;
        -h|--help)
            SHOW_HELP=1
            shift
            ;;
        --)
            shift; break ;;
        *)  echo "Internal error!" ; exit 1 ;;
    esac
done

if [[ $SHOW_HELP -eq 1 ]]; then
    cat <<EOF
Usage: $0 [--os ubuntu/jammy]
Override detected OS and version (default autodetect).
EOF
    exit 0
fi

################### OS & Version Detection ###################
if [[ -n "$OVERRIDE_OS" && -n "$OVERRIDE_CODENAME" ]]; then
    ID="$OVERRIDE_OS"
    VERSION_CODENAME="$OVERRIDE_CODENAME"
    echo "[WARN] OS override: Using '$ID' / '$VERSION_CODENAME' from argument."
else
    . /etc/os-release
    if [[ -z "$ID" || -z "$VERSION_CODENAME" ]]; then
        echo "[ERROR] Unable to autodetect OS or codename. Try --os ubuntu/jammy."
        exit 1
    fi
fi

SUPPORTED_IDS=("ubuntu" "debian")
if [[ ! " ${SUPPORTED_IDS[@]} " =~ " ${ID} " ]]; then
    echo "[ERROR] Unsupported OS '$ID'. Supported: ${SUPPORTED_IDS[*]}"
    exit 1
fi

if [[ -z "$VERSION_CODENAME" ]]; then
    echo "[ERROR] Cannot determine OS version codename (e.g., 'jammy', 'bullseye'). Aborting."
    exit 1
fi

# Define console log level (1=DEBUG, 2=INFO, 3=WARN, 4=ERROR)
LOG_LEVEL_CONSOLE=2

# Custom logging function
log() {
    local LEVEL="$1"
    shift
    local MSG="$*"
    local TIME=$(date +"%Y-%m-%d %H:%M:%S")

    local LEVEL_NUM=2
    case "$LEVEL" in
        DEBUG) LEVEL_NUM=1 ;;
        INFO)  LEVEL_NUM=2 ;;
        WARN)  LEVEL_NUM=3 ;;
        ERROR) LEVEL_NUM=4 ;;
    esac

    local LOG_STRING="[$TIME] [$LEVEL] $MSG"
    [ "$LEVEL_NUM" -ge "$LOG_LEVEL_CONSOLE" ] && echo "$LOG_STRING"
}

# Determine the actual user (handles if the script is run with sudo)
CURRENT_USER="${SUDO_USER:-$USER}"

if [[ "$CURRENT_USER" == "root" ]]; then
    log ERROR "Do not run this script as root. Please execute as a regular user with sudo permissions."
    exit 1
fi

log INFO "Detected OS: $ID ($VERSION_CODENAME) for user: $CURRENT_USER"

# 1. Remove old/conflicting packages and different versions
log INFO "Removing old Docker packages and different versions..."
sudo apt remove -y docker docker-engine docker.io docker-doc docker-compose podman-docker containerd runc docker-ce docker-ce-cli 2>/dev/null || log WARN "Some old packages could not be removed (they likely were not installed)."

# 2. Update package index and install prerequisites
log INFO "Updating package index and installing prerequisites..."
sudo apt update -qq || { log ERROR "Failed to update apt index."; exit 1; }
sudo apt install -y ca-certificates curl || { log ERROR "Failed to install prerequisites."; exit 1; }

# 3. Add Docker's official GPG key
log INFO "Downloading and configuring Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings || { log ERROR "Failed to create keyrings directory."; exit 1; }
sudo curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc || { log ERROR "Failed to download GPG key."; exit 1; }
sudo chmod a+r /etc/apt/keyrings/docker.asc || { log ERROR "Failed to set permissions on GPG key."; exit 1; }

# 4. Add the Docker repository
log INFO "Adding Docker repository to Apt sources..."
echo \
  "deb [arch=$(dpkg --print-architecture)] signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/$ID \
  $VERSION_CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || { log ERROR "Failed to add Docker repository."; exit 1; }

# 5. Install Docker packages
log INFO "Updating Apt index with new Docker repository..."
sudo apt update -qq || { log ERROR "Failed to update apt index with Docker repo."; exit 1; }

log INFO "Installing Docker CE, CLI, Containerd, and Compose plugins..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || { log ERROR "Failed to install Docker packages."; exit 1; }

# 6. Post-installation: Manage Docker as a non-root user
log INFO "Ensuring 'docker' group exists..."
getent group docker > /dev/null || sudo groupadd docker || { log ERROR "Failed to create docker group."; exit 1; }

log INFO "Adding user '$CURRENT_USER' to the 'docker' group..."
sudo usermod -aG docker "$CURRENT_USER" || { log ERROR "Failed to add user to docker group."; exit 1; }

log INFO "============================================================"
log INFO "Docker installation and configuration completed successfully!"
log WARN "IMPORTANT: You must log out and log back in (or reboot) for group changes to take effect."
log INFO "After re-login, test Docker with: docker run hello-world"
log INFO "============================================================"
