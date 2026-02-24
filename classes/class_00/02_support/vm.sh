#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# QEMU Launch Script (Authoring Mode)
# ============================================================
# Used by the instructor to maintain and update the class VM
# image. Not intended for student use.
# ============================================================

# --- Configurable Parameters --------------------------------
IMAGE_FILE="vm.qcow2"
VM_MEMORY="4G"
VM_CORES="4"
SSH_HOST_PORT="2222"
SSH_GUEST_PORT="22"

# --- Pre-flight Checks --------------------------------------

if [[ ! -f "${IMAGE_FILE}" ]]; then
    echo "Error: Disk image '${IMAGE_FILE}' not found in $(pwd)." >&2
    echo "Create one with: qemu-img create -f qcow2 ${IMAGE_FILE} 20G" >&2
    exit 1
fi

if [[ ! -e /dev/kvm ]]; then
    echo "Error: KVM is not available (/dev/kvm not found)." >&2
    echo "Ensure VT-x/AMD-V is enabled in BIOS and the kvm module is loaded." >&2
    exit 1
fi

if [[ ! -r /dev/kvm ]] || [[ ! -w /dev/kvm ]]; then
    echo "Error: Insufficient permissions on /dev/kvm." >&2
    echo "Add your user to the kvm group: sudo usermod -aG kvm \$(whoami)" >&2
    exit 1
fi

# --- Detect best async I/O backend --------------------------
# io_uring is fastest (kernel 5.1+), fall back to native/threads
AIO_BACKEND="threads"
if [[ -f /proc/version ]]; then
    KERNEL_MAJOR=$(uname -r | cut -d. -f1)
    KERNEL_MINOR=$(uname -r | cut -d. -f2)
    if (( KERNEL_MAJOR > 5 || (KERNEL_MAJOR == 5 && KERNEL_MINOR >= 1) )); then
        AIO_BACKEND="io_uring"
    fi
fi

# ============================================================
# Configuration Notes
# ============================================================
#
# MACHINE
#   q35: Modern PCIe-based chipset (replaces legacy i440FX).
#        Native PCIe support improves virtio device performance.
#
# GRAPHICS & INPUT
#   virtio-gpu-pci: Paravirtualized GPU with optional 3D accel.
#   usb-tablet:     Absolute pointing device (seamless mouse).
#
# DISK I/O
#   if=virtio:          Paravirtualized block driver (fastest).
#   aio=io_uring:       Async I/O via io_uring (kernel 5.1+).
#   discard=unmap:      TRIM support, marks deleted blocks as
#                       free (critical for shrinking qcow2).
#   detect-zeroes=unmap Treats zero-writes as discards, keeping
#                       the image sparse and small.
#   cache=writeback:    Faster I/O for non-critical workloads.
#
# NETWORKING
#   virtio-net-pci: Paravirtualized NIC.
#   hostfwd:        SSH access via localhost:${SSH_HOST_PORT}.
#
# BALLOON & RNG
#   virtio-balloon: Allows dynamic memory reclaim by the host.
#   virtio-rng:     Feeds guest /dev/random from host entropy,
#                   prevents stalls during boot, apt, keygen.
#
# AUDIO
#   intel-hda + hda-duplex: Standard HDA (optional).
# ============================================================

echo "Starting QEMU (Authoring Mode)..."
echo "  Image:  ${IMAGE_FILE}"
echo "  Memory: ${VM_MEMORY} | Cores: ${VM_CORES}"
echo "  AIO:    ${AIO_BACKEND}"
echo "  SSH:    ssh -p ${SSH_HOST_PORT} student@localhost"
echo ""

exec qemu-system-x86_64 \
  -machine type=q35,accel=kvm \
  -cpu host \
  -smp cores="${VM_CORES}",threads=1,sockets=1 \
  -m "${VM_MEMORY}" \
  -device virtio-gpu-pci \
  -display gtk,show-cursor=on \
  -usb -device usb-tablet \
  -drive "file=${IMAGE_FILE},if=virtio,format=qcow2,aio=${AIO_BACKEND},discard=unmap,detect-zeroes=unmap,cache=writeback" \
  -device virtio-net-pci,netdev=net0 \
  -netdev "user,id=net0,hostfwd=tcp::${SSH_HOST_PORT}-:${SSH_GUEST_PORT}" \
  -device virtio-balloon-pci \
  -device virtio-rng-pci \
  -device intel-hda -device hda-duplex
