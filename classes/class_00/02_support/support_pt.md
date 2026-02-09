---
title: Suporte à Configuração de VM/WSL
subtitle: Laboratórios de Sistemas e Serviços
author: Mário Antunes
institute: Universidade de Aveiro
date: 09 de Fevereiro de 2026
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

# Introdução: Escolha o Seu Ambiente

Para garantir um espaço de trabalho consistente, deve configurar um ambiente Linux. Escolha **uma** das seguintes opções com base no seu sistema operativo:

1.  **VirtualBox:** Melhor para PCs Windows e Linux com Intel/AMD. (Escolha Padrão).
2.  **VMware Workstation:** Alternativa de alto desempenho para Windows/Linux.
3.  **UTM:** A escolha **obrigatória** para Macs com Apple Silicon (chips M1/M2/M3).
4.  **WSL (Windows Subsystem for Linux):** Melhor para utilizadores avançados de Windows que preferem a integração do terminal em vez de uma VM com interface gráfica completa.

---

# Parte 1: Descarregar o Disco da Aula 📀

Para **VirtualBox, VMware e UTM**, precisa do disco Debian pré-configurado.

1.  **Descarregar:** [Descarregar Disco VM Debian (.vdi)](https://filesender.fccn.pt/?s=download&token=6eb748bf-0687-412f-822c-942fdb369ae8)
2.  **Guardar:** Guarde na pasta `Transferências` (Downloads) ou `Documentos`.

> **⚠️ Aviso de formato:** Este ficheiro está no formato `.vdi` (nativo do VirtualBox).
> * **VirtualBox:** Use como está.
> * **VMware/UTM:** Pode precisar de convertê-lo ou instalar um ISO Debian limpo se a importação falhar (Ver Apêndice A).

---

# Opção A: VirtualBox (Padrão para Windows/Mac Intel) 💻

**Não use isto em Macs Apple Silicon (M1/M2/M3). Use a Opção C (UTM).**

### 1. Instalação
1.  **Descarregar:** Vá a [virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).
2.  **Instalar Aplicação:** Descarregue e execute o instalador para o seu SO ("Windows hosts" ou "macOS / Intel hosts").
3.  **Instalar Extension Pack:** Descarregue o "Oracle VM VirtualBox Extension Pack" da mesma página e faça duplo clique para instalar.

### 2. Criar VM
1.  Abra o VirtualBox, clique em **Novo** (New).
    * **Nome:** `Debian IEI`
    * **Tipo:** `Linux` / **Versão:** `Debian (64-bit)`
2.  **RAM:** 4096 MB (4 GB) recomendado.
3.  **Disco Rígido:** Selecione **"Utilizar um Ficheiro de Disco Rígido Virtual Existente"**.
4.  Clique no ícone da pasta, navegue até ao ficheiro `.vdi` que descarregou e selecione-o.
5.  Clique em **Criar**.

### 3. Drivers (Guest Additions)
1.  Inicie a VM (Login: `student` / `password`).
2.  No menu da VM: **Dispositivos > Inserir imagem de CD dos Adicionais para Convidado...** (Devices > Insert Guest Additions CD image).
3.  Abra o Terminal na VM e execute:
    ```bash
    sudo apt update
    sudo apt install build-essential dkms linux-headers-$(uname -r)
    sudo mkdir -p /mnt/cdrom
    sudo mount /dev/cdrom /mnt/cdrom
    sudo /mnt/cdrom/VBoxLinuxAdditions.run
    sudo reboot
    ```
---

# Opção B: VMware Workstation (Windows/Linux) 🚀

O VMware Workstation Pro é agora **gratuito para uso pessoal** e frequentemente mais rápido que o VirtualBox.

### 1. Instalação
1.  **Descarregar:** Crie uma conta Broadcom e descarregue o **VMware Workstation Pro** (Windows) ou **VMware Fusion** (Mac - apenas Intel).
2.  **Instalar:** Execute o instalador. Selecione "I want to license for Personal Use" (não é necessária chave).

### 2. Criar VM (Importar VDI)
*Nota: O VMware usa `.vmdk`. Pode tentar selecionar o `.vdi` escolhendo "Todos os Ficheiros", mas a conversão é mais segura (Ver Apêndice A).*

1.  Clique em **"Create a New Virtual Machine"** > **Custom (Advanced)**.
2.  **Guest OS:** Linux > Debian 12 (64-bit).
3.  **Disk:** Escolha **"Use an existing virtual disk"**.
4.  Procure o seu ficheiro `.vmdk` convertido (ou tente o `.vdi`).
5.  Quando for pedido para converter (**"Convert"**) o formato, clique em **Yes**.

### 3. Drivers (Open-VM-Tools)
O VMware usa drivers open-source.
1.  Inicie a VM (Login: `student` / `password`).
2.  Abra o Terminal e execute:
    ```bash
    sudo apt update
    sudo apt install open-vm-tools-desktop
    sudo reboot
    ```
    *Isto ativa o copiar/colar, arrastar e largar e o redimensionamento automático.*

---

# Opção C: UTM (Mac Apple Silicon M1/M2/M3) 🍎

**Esta é a única opção com bom desempenho para Macs modernos.**

### 1. Instalação
1.  Descarregue o **UTM** em [mac.getutm.app](https://mac.getutm.app/) (Grátis) ou na Mac App Store (Pago/Doação).
2.  **Importante:** O disco da aula é `.vdi` (arquitetura x86). Emular x86 em Apple Silicon é **lento**.
    * *Recomendação:* É altamente recomendado **instalar um Debian ARM64 limpo** em vez de usar o disco da aula.
    * *Se tiver de usar o disco da aula:* Precisa de convertê-lo para `.qcow2` primeiro (Ver Apêndice A) e aceitar velocidades de emulação lentas.

### 2. Criar VM (Método de Instalação Limpa - Recomendado)
1.  Descarregue o **ISO Debian ARM64** em debian.org.
2.  Abra o UTM > **Create a New Virtual Machine**.
3.  **Virtualize** (Rápido) > **Linux**.
4.  **Boot Image:** Selecione o ISO Debian ARM64.
5.  Siga os passos do instalador.

### 3. Drivers (SPICE Agent)
Para obter partilha de área de transferência e resolução dinâmica:
1.  Abra o Terminal na VM.
2.  Execute:
    ```bash
    sudo apt update
    sudo apt install spice-vdagent
    sudo reboot
    ```
---

# Opção D: Windows Subsystem for Linux (WSL) 🪟

Executa Linux nativamente ao lado do Windows. Alto desempenho, mas sem uma janela de "Ambiente de Trabalho Virtual" por defeito.

### 1. Instalação
1.  Abra o **PowerShell** como Administrador.
2.  Execute:
    ```powershell
    wsl --install
    ```
3.  **Reinicie** o seu computador.
4.  Após reiniciar, o "Ubuntu" abrirá. Crie um nome de utilizador e palavra-passe.

### 2. Otimizar Rede (Modo Espelhado)

Para fazer o WSL comportar-se como um PC real na sua rede (corrigindo muitos problemas de conectividade):

1.  No Windows, pressione `Win+R`, escreva `%UserProfile%` e prima Enter.
2.  Crie um ficheiro chamado `.wslconfig` (certifique-se de que não é `.txt`).
3.  Cole este conteúdo:
    ```ini
    [wsl2]
    networkingMode=mirrored
    dnsTunneling=true
    autoProxy=true
    ```
4.  Reinicie o WSL: `wsl --shutdown` no PowerShell.

### 3. Aplicações Gráficas (GUI)
O WSL suporta aplicações gráficas (GUI) de origem. Tente executar:
```bash
sudo apt update && sudo apt install mousepad thunar
mousepad
```

---

# Apêndice A: Converter o Disco (.vdi) 🔧

Se não estiver a usar o VirtualBox, pode precisar de converter o ficheiro `.vdi` descarregado.

**Para VMware (VDI -> VMDK):**

Requer que o VirtualBox esteja instalado. Execute na Linha de Comandos (CMD):

```cmd
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonemedium disk "C:\Caminho\Para\Input.vdi" "C:\Caminho\Para\Output.vmdk" --format VMDK
```

**Para UTM (VDI -> QCOW2):**

Requer `qemu` (Instalar via Homebrew: `brew install qemu`).

```bash
qemu-img convert -f vdi -O qcow2 Input.vdi Output.qcow2
```
