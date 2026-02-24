---
title: "Support: VM/WSL Setup"
date: February 09, 2026
---

# Introduction: Choose Your Environment

To ensure a consistent workspace, you must set up a Linux environment. Choose **one** of the following options based on your operating system:

1.  **VirtualBox:** Best for Intel/AMD Windows and Linux PCs (Standard Choice).
2.  **VMware Workstation:** High-performance alternative for Windows/Linux.
3.  **UTM:** The **required** choice for Apple Silicon Macs (M1/M2/M3/M4 chips).
4.  **WSL (Windows Subsystem for Linux):** Best for advanced Windows users who prefer terminal integration over a full GUI VM.

---

# Part 1: Download the Class Disk

For **VirtualBox, VMware, and UTM**, you need the pre-configured Debian disk.

1.  **Download:** [Download Debian VM Disk (.vdi)](https://filesender.fccn.pt/?s=download&token=6eb748bf-0687-412f-822c-942fdb369ae8)
2.  **Save:** Save to `Downloads` or `Documents`.

**VM Credentials:**

| Field    | Value      |
|:---------|:-----------|
| Username | `student`  |
| Password | `password` |

> **Format note:** This file is in `.vdi` format (VirtualBox native).
>
> * **VirtualBox:** Use as is.
> * **VMware/UTM:** You may need to convert it or install a fresh Debian ISO if the import fails (see Appendix A).

---

# Option A: VirtualBox (Standard for Windows/Intel Mac)

**Do not use this on Apple Silicon (M1/M2/M3/M4) Macs. Use Option C (UTM) instead.**

### 1. Installation
1.  **Download:** Go to [virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).
2.  **Install App:** Download and run the installer for your OS ("Windows hosts" or "macOS / Intel hosts").
3.  **Install Extension Pack:** Download the "Oracle VM VirtualBox Extension Pack" from the same page and double-click it to install.

### 2. Create VM
1.  Open VirtualBox, click **New**.
    * **Name:** `Debian LSS`
    * **Type:** `Linux` / **Version:** `Debian (64-bit)`
2.  **RAM:** 4096 MB (4 GB) recommended.
3.  **Hard Disk:** Select **"Use an Existing Virtual Hard Disk File"**.
4.  Click the folder icon, navigate to the `.vdi` file you downloaded, and select it.
5.  Click **Create**.

### 3. Drivers (Guest Additions)
Guest Additions enable clipboard sharing, drag-and-drop, and automatic screen resizing.

1.  Start the VM and log in with the credentials above.
2.  In the VM menu: **Devices > Insert Guest Additions CD image**.
3.  Open a terminal in the VM and run:

```bash
sudo apt update
sudo apt install build-essential dkms linux-headers-$(uname -r)
sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
sudo /mnt/cdrom/VBoxLinuxAdditions.run
sudo reboot
```

**Alternative method** (simpler, uses Debian packages):

```bash
sudo apt update
sudo apt install virtualbox-guest-utils virtualbox-guest-x11
sudo reboot
```

### 4. Verify
After reboot, log in and open a terminal:

```bash
uname -a
```

You should see a Linux kernel version. Try resizing the VM window; the guest desktop should resize automatically.

---

# Option B: VMware Workstation (Windows/Linux)

VMware Workstation Pro is now **free for personal use** and often provides better performance than VirtualBox.

### 1. Installation
1.  **Download:** Create a Broadcom account and download **VMware Workstation Pro** (Windows) or **VMware Fusion** (Mac -- Intel only).
2.  **Install:** Run the installer. Select "I want to license for Personal Use" (no key required).

### 2. Create VM (Importing VDI)

VMware uses `.vmdk` format natively. You can try selecting the `.vdi` by choosing "All Files", but conversion is safer (see Appendix A).

1.  Click **"Create a New Virtual Machine"** > **Custom (Advanced)**.
2.  **Guest OS:** Linux > Debian 12 (64-bit).
3.  **Disk:** Choose **"Use an existing virtual disk"**.
4.  Browse for your converted `.vmdk` file (or try the `.vdi` directly).
5.  When asked to **"Convert"** the format, click **Yes**.

### 3. Drivers (Open-VM-Tools)
VMware uses open-source drivers that enable clipboard sharing, drag-and-drop, and automatic screen resizing.

1.  Start the VM and log in with the credentials above.
2.  Open a terminal and run:

```bash
sudo apt update
sudo apt install open-vm-tools-desktop
sudo reboot
```

### 4. Verify
After reboot, log in and open a terminal:

```bash
uname -a
```

Try copying text between the host and guest to confirm clipboard integration works.

---

# Option C: UTM (Apple Silicon Mac M1/M2/M3/M4)

**This is the only performant option for modern Macs.**

### 1. Installation
1.  Download **UTM** from [mac.getutm.app](https://mac.getutm.app/) (Free) or the Mac App Store (Paid/Donation).
2.  **Important:** The class disk is `.vdi` (x86 architecture). Emulating x86 on Apple Silicon is **slow**.
    * *Recommendation:* It is highly recommended to **install a fresh ARM64 Debian** instead of using the class disk.
    * *If you must use the class disk:* You need to convert it to `.qcow2` first (see Appendix A) and accept slow emulation speeds.

### 2. Create VM (Fresh Install Method -- Recommended)
1.  Download the **Debian ARM64 ISO** from [debian.org](https://www.debian.org/).
2.  Open UTM > **Create a New Virtual Machine**.
3.  **Virtualize** (Fast) > **Linux**.
4.  **Boot Image:** Select the Debian ARM64 ISO.
5.  Follow the installer steps. Use the same credentials as the class disk for consistency.

### 3. Drivers (SPICE Agent)
To get clipboard sharing and dynamic resolution:

1.  Open a terminal in the VM.
2.  Run:

```bash
sudo apt update
sudo apt install spice-vdagent
sudo reboot
```

### 4. Verify
After reboot, log in and open a terminal:

```bash
uname -a
```

You should see `aarch64` in the output, confirming the ARM64 architecture.

---

# Option D: Windows Subsystem for Linux (WSL)

Runs Linux natively alongside Windows. High performance, but no virtual desktop window by default.

### 1. Installation
1.  Open **PowerShell** as Administrator.
2.  Run:

```powershell
wsl --install
```

3.  **Reboot** your computer.
4.  After reboot, "Ubuntu" will open. Create a username and password.

### 2. Keep WSL Updated

After initial setup, ensure WSL and the distribution are up to date:

```powershell
wsl --update
```

### 3. Optimize Networking (Mirrored Mode)

To make WSL behave like a real PC on your network (fixing many connectivity issues):

1.  In Windows, press `Win+R`, type `%UserProfile%`, and hit Enter.
2.  Create a file named `.wslconfig` (make sure it is not `.wslconfig.txt`).
3.  Paste this content:

```ini
[wsl2]
networkingMode=mirrored
dnsTunneling=true
autoProxy=true
```

4.  Restart WSL from PowerShell: `wsl --shutdown`.

### 4. GUI Apps
WSL supports GUI applications out of the box (via WSLg). Test it:

```bash
sudo apt update && sudo apt install mousepad thunar
mousepad
```

A text editor window should appear on your Windows desktop.

### 5. Verify

```bash
cat /etc/os-release
uname -r
```

You should see the Ubuntu version and a Linux kernel version containing `WSL` or `microsoft`.

---

# Post-Setup: Common First Steps

Regardless of which option you chose, perform the following steps in your new Linux environment.

### 1. Update the System

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Essential Tools

```bash
sudo apt install -y git curl wget vim nano net-tools
```

### 3. Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@ua.pt"
```

### 4. Verify Everything Works

```bash
echo "Hello from Linux!"
uname -a
git --version
```

---

# Troubleshooting

### VT-x / AMD-V Not Enabled

**Symptom:** VirtualBox or VMware fails to start the VM with a "VT-x is disabled" or "AMD-V is not available" error.

**Fix:** Restart your computer, enter the BIOS/UEFI settings (usually by pressing `F2`, `F12`, `Del`, or `Esc` during boot), and enable **Intel VT-x** or **AMD-V** (sometimes labeled "SVM Mode") under the CPU or Security settings.

### Hyper-V Conflicts on Windows

**Symptom:** VirtualBox reports that Hyper-V is active and VT-x cannot be used.

**Fix:** Hyper-V and VirtualBox compete for hardware virtualization. You can disable Hyper-V:

```powershell
bcdedit /set hypervisorlaunchtype off
```

Reboot after running this command. To re-enable Hyper-V later:

```powershell
bcdedit /set hypervisorlaunchtype auto
```

> **Note:** Disabling Hyper-V also disables WSL 2, Windows Sandbox, and Credential Guard. If you need those, consider using VMware or WSL instead of VirtualBox.

### Network Not Working in VM

**Symptom:** The VM has no internet access.

**Fix:** Check the VM network adapter settings:

* Ensure the adapter is set to **NAT** (the simplest mode).
* Verify your host machine has internet access.
* Inside the VM, check the adapter status: `ip addr show` and `ping -c 3 8.8.8.8`.
* Restart networking: `sudo systemctl restart NetworkManager`.

### Secure Boot Issues

**Symptom:** The VM fails to boot or kernel modules (like VirtualBox Guest Additions) fail to load.

**Fix:** Some systems require Secure Boot to be disabled in BIOS/UEFI for third-party kernel modules to load. Disable it in the BIOS/UEFI settings under the Security or Boot tab.

---

# Appendix A: Converting the Disk (.vdi)

If you are not using VirtualBox, you may need to convert the downloaded `.vdi` file.

### For VMware (VDI to VMDK)

Requires VirtualBox to be installed (for `VBoxManage`). Run in Command Prompt:

```cmd
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" ^
  clonemedium disk "C:\Path\To\Input.vdi" ^
  "C:\Path\To\Output.vmdk" --format VMDK
```

### For UTM (VDI to QCOW2)

Requires `qemu-img`. Install via Homebrew on macOS:

```bash
brew install qemu
qemu-img convert -f vdi -O qcow2 Input.vdi Output.qcow2
```

On Windows, `qemu-img` is available by installing QEMU for Windows, or you can run the conversion inside WSL:

```bash
sudo apt install qemu-utils
qemu-img convert -f vdi -O qcow2 /mnt/c/Path/To/Input.vdi Output.qcow2
```
