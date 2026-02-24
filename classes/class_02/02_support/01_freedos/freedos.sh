#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# FreeDOS QEMU Helper Script
# Emulates a FreeDOS environment with sound card support for classic DOS games.
# =============================================================================

# Default variables
DISK="freedos_disk.qcow2"
DISK_SIZE="500M"
IMAGE_URL="https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.4/FD14-LiveCD.zip"
DOOM_URL="https://github.com/detiuaveiro/lss/blob/master/classes/class_02/02_support/01_freedos/games/doom19s.zip?raw=true"
RESTART=false

# Temporary directories
TMP_FREEDOS="/tmp/freedos_$$"
TMP_GAMES="/tmp/games_$$"

# -----------------------------------------------------------------------------
# Cleanup on exit
# -----------------------------------------------------------------------------
cleanup() {
    rm -rf "$TMP_FREEDOS" "$TMP_GAMES"
}
trap cleanup EXIT

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------
preflight() {
    local missing=()

    for cmd in qemu-system-i386 qemu-img curl unzip; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "ERROR: The following required commands are not installed: ${missing[*]}"
        echo "On Debian/Ubuntu, try:  sudo apt install qemu-system-x86 qemu-utils curl unzip"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------
Help() {
    echo "Helper script to emulate FreeDOS using QEMU"
    echo
    echo "Usage: $(basename "$0") [-h] [-r] [-d <disk_name>] [-s <disk_size>]"
    echo
    echo "Options:"
    echo "  -d <disk_name>   Set the disk image filename (default: $DISK)"
    echo "  -h               Print this help message"
    echo "  -r               Restart: delete the disk and re-run setup"
    echo "  -s <disk_size>   Set the disk size (default: $DISK_SIZE)"
    echo
    echo "Examples:"
    echo "  $(basename "$0")              # Normal start (setup on first run)"
    echo "  $(basename "$0") -r           # Delete disk and re-install FreeDOS"
    echo "  $(basename "$0") -s 1G        # Use a 1 GB disk"
    echo
}

# -----------------------------------------------------------------------------
# Detect KVM availability
# -----------------------------------------------------------------------------
accel_flag() {
    if [[ -r /dev/kvm ]]; then
        echo "kvm"
    else
        echo "tcg"
    fi
}

# -----------------------------------------------------------------------------
# Setup: Download FreeDOS ISO and install to disk
# -----------------------------------------------------------------------------
Setup() {
    echo "[*] Creating QEMU disk image: $DISK ($DISK_SIZE)"
    qemu-img create -f qcow2 "$DISK" "$DISK_SIZE" >/dev/null 2>&1

    if [[ ! -f FreeDos.zip ]]; then
        echo "[*] Downloading FreeDOS Live CD..."
        curl -L "$IMAGE_URL" --output FreeDos.zip --progress-bar
    fi

    mkdir -p "$TMP_FREEDOS"
    unzip -o FreeDos.zip -d "$TMP_FREEDOS"

    local iso
    iso=$(find "$TMP_FREEDOS" -iname '*.iso' -print -quit)
    if [[ -z "$iso" ]]; then
        echo "ERROR: Could not find an ISO file inside FreeDos.zip"
        exit 1
    fi

    local accel
    accel=$(accel_flag)
    echo "[*] Starting FreeDOS installer (accel=$accel)..."
    echo "[*] Install FreeDOS to the virtual hard disk, then close the window."

    qemu-system-i386 \
        -machine "accel=$accel:tcg" \
        -m 128 \
        -cpu host \
        -k pt \
        -rtc base=localtime \
        -device adlib \
        -device sb16 \
        -device cirrus-vga \
        -display gtk \
        -hda "$DISK" \
        -cdrom "$iso" \
        -boot d
}

# -----------------------------------------------------------------------------
# Main program
# -----------------------------------------------------------------------------
preflight

# Process options
while getopts ":d:s:rh" option; do
    case $option in
        h)
            Help
            exit 0
            ;;
        d)
            DISK="${OPTARG}"
            ;;
        s)
            DISK_SIZE="${OPTARG}"
            ;;
        r)
            RESTART=true
            ;;
        \?)
            echo "ERROR: Invalid option: -${OPTARG}."
            Help
            exit 1
            ;;
    esac
done

echo "[*] Disk: $DISK (size: $DISK_SIZE)"

# Handle restart
if [[ "$RESTART" == true ]]; then
    echo "[*] Restarting: deleting $DISK"
    rm -f "$DISK"
fi

# Run setup if disk does not exist
if [[ ! -f "$DISK" ]]; then
    echo "[*] FreeDOS disk not found, initiating setup..."
    Setup
fi

# Download DOOM if not present
if [[ ! -f games/doom19s.zip ]]; then
    echo "[*] Downloading DOOM shareware..."
    mkdir -p games
    curl -L "$DOOM_URL" --output games/doom19s.zip --progress-bar
fi

# Prepare game files on a virtual FAT drive
echo "[*] Preparing game files on virtual FAT drive..."
mkdir -p "$TMP_GAMES/doom"
unzip -o games/doom19s.zip -d "$TMP_GAMES/doom/"

# Launch FreeDOS with game drive
local_accel=$(accel_flag)
echo "[*] Starting FreeDOS (accel=$local_accel)..."
echo "[*] Game files are available on drive D:"

qemu-system-i386 \
    -machine "accel=$local_accel:tcg" \
    -m 128 \
    -cpu host \
    -k pt \
    -rtc base=localtime \
    -device adlib \
    -device sb16 \
    -device cirrus-vga \
    -display gtk \
    -hda "$DISK" \
    -boot c \
    -drive "file=fat:rw:$TMP_GAMES/doom,format=raw"

echo "[*] Done."
