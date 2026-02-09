#!/usr/bin/env bash

# Image filename variable for easy changing
IMAGE_FILE="vm.qcow2"

echo -e "🚀 Starting QEMU (Authoring Mode)..."

qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp cores=4,threads=1 \
  -m 4G \
  \
  # --- GRAPHICS & INPUT (Better than SDL) ---
  # virtio-gpu-pci: Newer standard for 3D acceleration
  # usb-tablet: Absolute pointing device (mouse doesn't get 'stuck' in window)
  -device virtio-gpu-pci \
  -display default,show-cursor=on \
  -usb -device usb-tablet \
  \
  # --- DISK I/O (Optimized for Maintenance) ---
  # if=virtio: Paravirtualized driver (faster than IDE/SATA emulation)
  # discard=unmap: Allows the OS to mark deleted blocks as empty (CRITICAL for shrinking image)
  # cache=writeback: Faster IO, slightly risky if host crashes, but fine for updates
  -drive file="${IMAGE_FILE}",if=virtio,format=qcow2,discard=unmap,cache=writeback \
  \
  # --- NETWORKING ---
  # virtio-net-pci: Faster networking
  # hostfwd: Forward host port 2222 to guest 22 (allows you to SSH in: ssh -p 2222 student@localhost)
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  \
  # --- AUDIO (Optional, standard HDA) ---
  -device intel-hda -device hda-duplex
