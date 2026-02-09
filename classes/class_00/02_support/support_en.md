---
title: Support VM/WSL Setup
subtitle: Laboratórios de Sistemas e Serviços
author: Mário Antunes
institute: Universidade de Aveiro
date: February 09, 2026
colorlinks: true
highlight-style: tango
mainfont: NotoSans
mainfontfallback: "NotoColorEmoji:mode=harf"
header-includes:
 - \usepackage{booktabs}
 - \usepackage{etoolbox}
 - \AtBeginEnvironment{cslreferences}{\tiny}
 - \AtBeginEnvironment{Shaded}{\normalsize}
 - \AtBeginEnvironment{verbatim}{\normalsize}
 - \setmonofont[Contextuals={Alternate}]{FiraCodeNerdFontMono-Retina}
---

# Introduction: Choose Your Environment

To ensure a consistent workspace, you must set up a Linux environment. Choose **one** of the following options based on your operating system:

1.  **VirtualBox:** Best for Intel/AMD Windows & Linux PCs. (Standard Choice).
2.  **VMware Workstation:** High-performance alternative for Windows/Linux.
3.  **UTM:** The **required** choice for Apple Silicon Macs (M1/M2/M3 chips).
4.  **WSL (Windows Subsystem for Linux):** Best for advanced Windows users who prefer terminal integration over a full GUI VM.

---

# Part 1: Download the Class Disk 📀

For **VirtualBox, VMware, and UTM**, you need the pre-configured Debian disk.

1.  **Download:** [Download Debian VM Disk (.vdi)](https://filesender.fccn.pt/?s=download&token=6eb748bf-0687-412f-822c-942fdb369ae8)
2.  **Save:** Save to `Downloads` or `Documents`.

> **⚠️ format Warning:** This file is in `.vdi` format (VirtualBox native).
> * **VirtualBox:** Use as is.
> * **VMware/UTM:** You may need to convert it or install a fresh Debian ISO if the import fails (See Appendix A).

---

# Option A: VirtualBox (Standard for Windows/Intel Mac) 💻

**Do not use this on Apple Silicon (M1/M2/M3) Macs. Use Option C (UTM) instead.**

### 1. Installation
1.  **Download:** Go to [virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).
2.  **Install App:** Download and run the installer for your OS ("Windows hosts" or "macOS / Intel hosts").
3.  **Install Extension Pack:** Download the "Oracle VM VirtualBox Extension Pack" from the same page and double-click it to install.

### 2. Create VM
1.  Open VirtualBox, click **New**.
    * **Name:** `Debian IEI`
    * **Type:** `Linux` / **Version:** `Debian (64-bit)`
2.  **RAM:** 4096 MB (4 GB) recommended.
3.  **Hard Disk:** Select **"Use an Existing Virtual Hard Disk File"**.
4.  Click the folder icon, navigate to the `.vdi` file you downloaded, and select it.
5.  Click **Create**.

### 3. Drivers (Guest Additions)
1.  Start the VM (Login: `student` / `password`).
2.  In the VM menu: **Devices > Insert Guest Additions CD image**.
3.  Open Terminal in VM and run:
    ```bash
    sudo apt update
    sudo apt install build-essential dkms linux-headers-$(uname -r)
    sudo mkdir -p /mnt/cdrom
    sudo mount /dev/cdrom /mnt/cdrom
    sudo /mnt/cdrom/VBoxLinuxAdditions.run
    sudo reboot
    ```

---

# Option B: VMware Workstation (Windows/Linux) 🚀

VMware Workstation Pro is now **free for personal use** and often faster than VirtualBox.

### 1. Installation
1.  **Download:** Create a Broadcom account and download **VMware Workstation Pro** (Windows) or **VMware Fusion** (Mac - Intel only).
2.  **Install:** Run the installer. Select "I want to license for Personal Use" (no key required).

### 2. Create VM (Importing VDI)
*Note: VMware uses `.vmdk`. You can try selecting the `.vdi` by choosing "All Files", but conversion is safer (See Appendix A).*

1.  Click **"Create a New Virtual Machine"** > **Custom (Advanced)**.
2.  **Guest OS:** Linux > Debian 12 (64-bit).
3.  **Disk:** Choose **"Use an existing virtual disk"**.
4.  Browse for your converted `.vmdk` file (or try the `.vdi`).
5.  When asked to **"Convert"** the format, click **Yes**.

### 3. Drivers (Open-VM-Tools)
VMware uses open-source drivers.
1.  Start VM (Login: `student` / `password`).
2.  Open Terminal and run:
    ```bash
    sudo apt update
    sudo apt install open-vm-tools-desktop
    sudo reboot
    ```
    *This enables copy/paste, drag-and-drop, and auto-resizing.*

---

# Option C: UTM (Apple Silicon Mac M1/M2/M3) 🍎

**This is the only performant option for modern Macs.**

### 1. Installation
1.  Download **UTM** from [mac.getutm.app](https://mac.getutm.app/) (Free) or the Mac App Store (Paid/Donation).
2.  **Important:** The class disk is `.vdi` (x86 architecture). Emulating x86 on Apple Silicon is **slow**.
    * *Recommendation:* It is highly recommended to **install a fresh ARM64 Debian** instead of using the class disk.
    * *If you must use the class disk:* You need to convert it to `.qcow2` first (See Appendix A) and accept slow emulation speeds.

### 2. Create VM (Fresh Install Method - Recommended)
1.  Download the **Debian ARM64 ISO** from debian.org.
2.  Open UTM > **Create a New Virtual Machine**.
3.  **Virtualize** (Fast) > **Linux**.
4.  **Boot Image:** Select the Debian ARM64 ISO.
5.  Follow the installer steps.

### 3. Drivers (SPICE Agent)
To get clipboard sharing and dynamic resolution:
1.  Open Terminal in VM.
2.  Run:
    ```bash
    sudo apt update
    sudo apt install spice-vdagent
    sudo reboot
    ```

---

# Option D: Windows Subsystem for Linux (WSL) 🪟

Runs Linux natively alongside Windows. High performance, but no "Virtual Desktop" window by default.

### 1. Installation
1.  Open **PowerShell** as Administrator.
2.  Run:
    ```powershell
    wsl --install
    ```
3.  **Reboot** your computer.
4.  After reboot, "Ubuntu" will open. Create a username/password.

### 2. Optimize Networking (Mirrored Mode)

To make WSL behave like a real PC on your network (fixing many connectivity issues):

1.  In Windows, press `Win+R`, type `%UserProfile%`, and hit Enter.
2.  Create a file named `.wslconfig` (make sure it's not `.txt`).
3.  Paste this content:
    ```ini
    [wsl2]
    networkingMode=mirrored
    dnsTunneling=true
    autoProxy=true
    ```
4.  Restart WSL: `wsl --shutdown` in PowerShell.

### 3. GUI Apps
WSL supports GUI apps out of the box. Try running:
```bash
sudo apt update && sudo apt install gedit nautilus
gedit
```

(The editor should appear in a window).

---

# Appendix A: Converting the Disk (.vdi) 🔧

If you are not using VirtualBox, you may need to convert the downloaded `.vdi` file.

**For VMware (VDI -> VMDK):**

Requires VirtualBox to be installed. Run in Command Prompt:

```cmd
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonemedium disk "C:\Path\To\Input.vdi" "C:\Path\To\Output.vmdk" --format VMDK
```

**For UTM (VDI -> QCOW2):**

Requires `qemu` (Install via Homebrew: `brew install qemu`).

```bash
qemu-img convert -f vdi -O qcow2 Input.vdi Output.qcow2
```
