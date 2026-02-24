#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Proxmox VE QEMU Helper Script
# Launches a Proxmox VE VM with NAT or bridged networking.
# Uses modern QEMU options: q35 machine type, virtio devices.
# Port 8006 is forwarded for the Proxmox web interface in NAT mode.
# =============================================================================

# Default variables
DISK="proxmox_disk.qcow2"
DISK_SIZE="32G"
IMAGE_URL="https://enterprise.proxmox.com/iso/proxmox-ve_9.0-1.iso"
ISO_FILE="proxmox.iso"
NETWORK="nat"
RESTART=false

# Detect default network interface
INTERFACE=""
if command -v ip &>/dev/null; then
    INTERFACE=$(ip route get 8.8.8.8 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -1) || true
fi

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------
preflight() {
    local missing=()

    for cmd in qemu-system-x86_64 qemu-img curl; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "ERROR: The following required commands are not installed: ${missing[*]}"
        echo "On Debian/Ubuntu, try:  sudo apt install qemu-system-x86 qemu-utils curl"
        exit 1
    fi

    if [[ "$NETWORK" == "bridge" ]]; then
        for cmd in ip dhclient; do
            if ! command -v "$cmd" &>/dev/null; then
                missing+=("$cmd")
            fi
        done
        if [[ ${#missing[@]} -gt 0 ]]; then
            echo "ERROR: Bridge mode requires: ${missing[*]}"
            echo "On Debian/Ubuntu, try:  sudo apt install iproute2 isc-dhcp-client bridge-utils"
            exit 1
        fi
    fi
}

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------
Help() {
    echo "Helper script to run Proxmox VE using QEMU"
    echo
    echo "Usage: $(basename "$0") [-h] [-r] [-d <disk_name>] [-s <disk_size>] [-n {nat|bridge}]"
    echo
    echo "Options:"
    echo "  -d <disk_name>    Set the disk image filename (default: $DISK)"
    echo "  -h                Print this help message"
    echo "  -n {nat|bridge}   Set the network type (default: nat)"
    echo "  -r                Restart: delete the disk and re-run setup"
    echo "  -s <disk_size>    Set the disk size (default: $DISK_SIZE)"
    echo
    echo "Examples:"
    echo "  $(basename "$0")                # Start with NAT (setup on first run)"
    echo "  $(basename "$0") -r             # Delete disk and re-install Proxmox"
    echo "  $(basename "$0") -n bridge      # Start with bridged networking"
    echo
    echo "NAT port forward:"
    echo "  Host :8006  ->  Guest :8006  (Proxmox Web UI)"
    echo
    echo "After boot, access the web interface at: https://localhost:8006"
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
# Setup: Download Proxmox ISO and run installer
# -----------------------------------------------------------------------------
Setup() {
    echo "[*] Creating QEMU disk image: $DISK ($DISK_SIZE)"
    qemu-img create -f qcow2 "$DISK" "$DISK_SIZE" >/dev/null 2>&1

    if [[ ! -f "$ISO_FILE" ]]; then
        echo "[*] Downloading Proxmox VE ISO..."
        echo "[*] URL: $IMAGE_URL"
        curl -L "$IMAGE_URL" --output "$ISO_FILE" --progress-bar
    fi

    local accel
    accel=$(accel_flag)
    echo "[*] Starting Proxmox installer (accel=$accel)..."
    echo "[*] Follow the graphical installer inside the VM."
    echo "[*] After installation, close the window to continue."

    qemu-system-x86_64 \
        -machine "q35,accel=$accel:tcg" \
        -m 4G \
        -smp 4 \
        -cpu host \
        -k pt \
        -rtc base=localtime \
        -display gtk \
        -drive "file=$DISK,format=qcow2,if=virtio,aio=threads,cache=writeback" \
        -device virtio-rng-pci \
        -cdrom "$ISO_FILE" \
        -boot d \
        -nic user,model=virtio-net-pci,hostfwd=tcp::8006-:8006
}

# -----------------------------------------------------------------------------
# NAT mode: port forwarding for Proxmox Web UI (8006->8006)
# -----------------------------------------------------------------------------
VM_NAT() {
    local accel
    accel=$(accel_flag)
    echo "[*] Starting Proxmox VE (NAT, accel=$accel)"
    echo "[*] Web UI: https://localhost:8006"

    qemu-system-x86_64 \
        -machine "q35,accel=$accel:tcg" \
        -m 4G \
        -smp 4 \
        -cpu host \
        -k pt \
        -rtc base=localtime \
        -display gtk \
        -drive "file=$DISK,format=qcow2,if=virtio,aio=threads,cache=writeback,detect-zeroes=unmap" \
        -device virtio-rng-pci \
        -device virtio-balloon-pci \
        -nic user,model=virtio-net-pci,hostfwd=tcp::8006-:8006
}

# -----------------------------------------------------------------------------
# Bridge mode: VM gets an IP from the local network
# Requires root privileges and a wired connection.
# -----------------------------------------------------------------------------
VM_BRIDGE() {
    if [[ -z "$INTERFACE" ]]; then
        echo "ERROR: Could not detect a network interface for bridging."
        echo "[*] Falling back to NAT mode."
        VM_NAT
        return
    fi

    local accel
    accel=$(accel_flag)
    echo "[*] Setting up bridge interface on $INTERFACE..."

    sudo ip link add virtbr0 type bridge
    sudo ip link set dev "$INTERFACE" master virtbr0
    sudo ip addr flush dev "$INTERFACE"
    sudo dhclient virtbr0
    sudo ip link set dev "$INTERFACE" up
    sudo ip link set dev virtbr0 up

    echo "[*] Starting Proxmox VE (BRIDGE, accel=$accel)"
    echo "[*] The VM will get an IP from your local network."
    echo "[*] Check the Proxmox console for the Web UI URL."

    sudo qemu-system-x86_64 \
        -machine "q35,accel=$accel:tcg" \
        -m 4G \
        -smp 4 \
        -cpu host \
        -k pt \
        -rtc base=localtime \
        -display gtk \
        -drive "file=$DISK,format=qcow2,if=virtio,aio=threads,cache=writeback,detect-zeroes=unmap" \
        -device virtio-rng-pci \
        -device virtio-balloon-pci \
        -netdev bridge,id=net0,br=virtbr0 \
        -device virtio-net-pci,netdev=net0

    echo "[*] Cleaning up bridge interface..."
    sudo ip link set virtbr0 down
    sudo ip link del virtbr0
    sudo dhclient "$INTERFACE"
}

# -----------------------------------------------------------------------------
# Main program
# -----------------------------------------------------------------------------

# Process options
while getopts ":d:s:n:rh" option; do
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
        n)
            NETWORK="${OPTARG}"
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

# Run pre-flight checks (after option parsing so NETWORK is set)
preflight

echo "[*] Disk: $DISK (size: $DISK_SIZE)"
echo "[*] Network mode: $NETWORK"

# Handle restart
if [[ "$RESTART" == true ]]; then
    echo "[*] Restarting: deleting $DISK"
    rm -f "$DISK"
fi

# Run setup if disk does not exist
if [[ ! -f "$DISK" ]]; then
    echo "[*] Proxmox disk not found, initiating setup..."
    Setup
fi

# Launch VM with selected network mode
case "$NETWORK" in
    nat)
        VM_NAT
        ;;
    bridge)
        VM_BRIDGE
        ;;
    *)
        echo "ERROR: Unknown network type '$NETWORK'. Use 'nat' or 'bridge'."
        exit 1
        ;;
esac

echo "[*] Done."
