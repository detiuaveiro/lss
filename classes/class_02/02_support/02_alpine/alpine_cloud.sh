#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Alpine Linux Cloud-Init QEMU Helper Script
# Launches a pre-built Alpine Linux cloud image with cloud-init configuration.
# Uses modern QEMU options: q35 machine type, virtio devices.
# =============================================================================

# Default variables
DISK="alpine_cloud.qcow2"
CONFIG_IMG="config.img"
IMAGE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/cloud/generic_alpine-3.22.1-x86_64-bios-cloudinit-r0.qcow2"
RESTART=false

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------
preflight() {
    local missing=()

    for cmd in qemu-system-x86_64 qemu-img curl dd mkfs.vfat; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "ERROR: The following required commands are not installed: ${missing[*]}"
        echo "On Debian/Ubuntu, try:  sudo apt install qemu-system-x86 qemu-utils curl dosfstools"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------
Help() {
    echo "Helper script to run Alpine Linux (cloud image) using QEMU"
    echo
    echo "Usage: $(basename "$0") [-h] [-r]"
    echo
    echo "Options:"
    echo "  -h    Print this help message"
    echo "  -r    Restart: delete the disk and cloud-init image, then re-download"
    echo
    echo "This script downloads an Alpine Linux cloud image and boots it with"
    echo "a cloud-init configuration that creates a 'student' user with SSH access."
    echo
    echo "NAT port forward:"
    echo "  Host :2222  ->  Guest :22  (SSH)"
    echo
    echo "After boot, connect with:  ssh -p 2222 student@localhost"
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
# Setup: Download Alpine cloud image
# -----------------------------------------------------------------------------
Setup() {
    echo "[*] Downloading Alpine Linux cloud image..."
    echo "[*] URL: $IMAGE_URL"
    curl -L "$IMAGE_URL" --output "$DISK" --progress-bar

    # Resize the disk to give more space for packages
    echo "[*] Resizing cloud image to 4G..."
    qemu-img resize "$DISK" 4G
}

# -----------------------------------------------------------------------------
# Create cloud-init config drive
# -----------------------------------------------------------------------------
CreateConfigDrive() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [[ ! -f "$script_dir/user-data" ]]; then
        echo "ERROR: user-data file not found in $script_dir"
        echo "Please create a user-data file with your cloud-init configuration."
        exit 1
    fi

    if [[ ! -f "$script_dir/meta-data" ]]; then
        echo "ERROR: meta-data file not found in $script_dir"
        echo "Please create a meta-data file with your instance metadata."
        exit 1
    fi

    echo "[*] Creating cloud-init config drive..."

    # Create empty FAT image with cidata label
    dd if=/dev/zero of="$CONFIG_IMG" bs=1 count=0 seek=2M >/dev/null 2>&1
    mkfs.vfat -n cidata "$CONFIG_IMG" >/dev/null 2>&1

    # Mount and copy cloud-init files
    local mnt_dir
    mnt_dir=$(mktemp -d)

    sudo mount "$CONFIG_IMG" "$mnt_dir"
    sudo cp -f "$script_dir/user-data" "$mnt_dir/user-data"
    sudo cp -f "$script_dir/meta-data" "$mnt_dir/meta-data"
    sudo umount "$mnt_dir"
    rmdir "$mnt_dir"

    echo "[*] Cloud-init config drive created successfully."
}

# -----------------------------------------------------------------------------
# Main program
# -----------------------------------------------------------------------------
preflight

# Process options
while getopts "rh" option; do
    case $option in
        h)
            Help
            exit 0
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

# Handle restart
if [[ "$RESTART" == true ]]; then
    echo "[*] Restarting: deleting $DISK and $CONFIG_IMG"
    rm -f "$DISK" "$CONFIG_IMG"
fi

# Download cloud image if not present
if [[ ! -f "$DISK" ]]; then
    echo "[*] Alpine cloud disk not found, initiating setup..."
    Setup
fi

# Create config drive if not present
if [[ ! -f "$CONFIG_IMG" ]]; then
    CreateConfigDrive
fi

# Launch the VM
accel=$(accel_flag)
echo "[*] Starting Alpine Linux cloud image (accel=$accel)"
echo "[*] SSH: ssh -p 2222 student@localhost"
echo "[*] Cloud-init will run on first boot (may take a minute)."

qemu-system-x86_64 \
    -machine "q35,accel=$accel:tcg" \
    -m 4G \
    -smp 4 \
    -cpu host \
    -k pt \
    -rtc base=localtime \
    -display gtk \
    -drive "file=$DISK,format=qcow2,if=virtio,aio=threads,cache=writeback,detect-zeroes=unmap" \
    -drive "file=$CONFIG_IMG,format=raw,if=virtio" \
    -device virtio-rng-pci \
    -device virtio-balloon-pci \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22

echo "[*] Done."
