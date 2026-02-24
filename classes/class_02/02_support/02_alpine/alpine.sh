#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Alpine Linux QEMU Helper Script
# Launches an Alpine Linux VM with NAT or bridged networking.
# Uses modern QEMU options: q35 machine type, virtio devices, io_uring.
# =============================================================================

# Default variables
DISK="alpine_disk.qcow2"
DISK_SIZE="10G"
IMAGE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/x86_64/alpine-standard-3.22.1-x86_64.iso"
NETWORK="nat"
RESTART=false

# Detect default network interface
INTERFACE=""
if command -v ip &>/dev/null; then
    INTERFACE=$(ip route get 8.8.8.8 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -1) || true
fi

# Detect wired vs wireless
detect_wired() {
    if [[ -z "$INTERFACE" ]]; then
        echo "false"
        return
    fi
    if [[ -d "/sys/class/net/$INTERFACE/wireless" ]]; then
        echo "false"
    elif [[ -f "/sys/class/net/$INTERFACE/carrier" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

WIRED=$(detect_wired)

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
    echo "Helper script to run Alpine Linux using QEMU"
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
    echo "  $(basename "$0") -r             # Delete disk and re-install Alpine"
    echo "  $(basename "$0") -n bridge      # Start with bridged networking"
    echo
    echo "NAT port forwards:"
    echo "  Host :2222  ->  Guest :22  (SSH)"
    echo "  Host :8080  ->  Guest :80  (HTTP)"
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
# Common QEMU flags
# -----------------------------------------------------------------------------
common_qemu_args() {
    local accel
    accel=$(accel_flag)

    echo \
        -machine "q35,accel=$accel:tcg" \
        -m 4G \
        -smp 4 \
        -cpu host \
        -k pt \
        -rtc base=localtime \
        -display gtk \
        -drive "file=$DISK,format=qcow2,if=virtio,aio=threads,cache=writeback,detect-zeroes=unmap" \
        -device virtio-rng-pci \
        -device virtio-balloon-pci
}

# -----------------------------------------------------------------------------
# Setup: Download Alpine ISO and run installer
# -----------------------------------------------------------------------------
Setup() {
    echo "[*] Creating QEMU disk image: $DISK ($DISK_SIZE)"
    qemu-img create -f qcow2 "$DISK" "$DISK_SIZE" >/dev/null 2>&1

    if [[ ! -f alpine.iso ]]; then
        echo "[*] Downloading Alpine Standard ISO..."
        curl -L "$IMAGE_URL" --output alpine.iso --progress-bar
    fi

    local accel
    accel=$(accel_flag)
    echo "[*] Starting Alpine installer (accel=$accel)..."
    echo "[*] Run 'setup-alpine' inside the VM to install. Disk device is 'vda'."

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
        -cdrom alpine.iso \
        -boot d \
        -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22
}

# -----------------------------------------------------------------------------
# NAT mode: port forwarding for SSH (2222->22) and HTTP (8080->80)
# -----------------------------------------------------------------------------
VM_NAT() {
    local accel
    accel=$(accel_flag)
    echo "[*] Starting Alpine Linux (NAT, accel=$accel)"
    echo "[*] SSH: ssh root@localhost -p 2222"
    echo "[*] HTTP: http://localhost:8080"

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
        -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80
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

    echo "[*] Starting Alpine Linux (BRIDGE, accel=$accel)"
    echo "[*] The VM will get an IP from your local network."

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

echo "[*] Interface: ${INTERFACE:-none} (Wired: $WIRED)"
echo "[*] Network mode: $NETWORK"

# Handle restart
if [[ "$RESTART" == true ]]; then
    echo "[*] Restarting: deleting $DISK"
    rm -f "$DISK"
fi

# Run setup if disk does not exist
if [[ ! -f "$DISK" ]]; then
    echo "[*] Alpine disk not found, initiating setup..."
    Setup
fi

# Launch VM with selected network mode
case "$NETWORK" in
    nat)
        VM_NAT
        ;;
    bridge)
        if [[ "$WIRED" == "false" ]]; then
            echo "[!] WARNING: Wireless connections do not support bridging."
            echo "[*] Falling back to NAT mode."
            VM_NAT
        else
            VM_BRIDGE
        fi
        ;;
    *)
        echo "ERROR: Unknown network type '$NETWORK'. Use 'nat' or 'bridge'."
        exit 1
        ;;
esac

echo "[*] Done."
