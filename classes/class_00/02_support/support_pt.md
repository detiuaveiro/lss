---
title: "Suporte: Configuração de VM/WSL"
date: 09 de Fevereiro de 2026
---

# Introdução: Escolha o Seu Ambiente

Para garantir um espaço de trabalho consistente, deve configurar um ambiente Linux. Escolha **uma** das seguintes opções com base no seu sistema operativo:

1.  **VirtualBox:** Melhor para PCs Windows e Linux com Intel/AMD (Escolha Padrão).
2.  **VMware Workstation:** Alternativa de alto desempenho para Windows/Linux.
3.  **UTM:** A escolha **obrigatória** para Macs com Apple Silicon (chips M1/M2/M3/M4).
4.  **WSL (Windows Subsystem for Linux):** Melhor para utilizadores avançados de Windows que preferem a integração do terminal em vez de uma VM com interface gráfica completa.

---

# Parte 1: Descarregar o Disco da Aula

Para **VirtualBox, VMware e UTM**, precisa do disco Debian pré-configurado.

1.  **Descarregar:** [Descarregar Disco VM Debian (.vdi)](https://filesender.fccn.pt/?s=download&token=6eb748bf-0687-412f-822c-942fdb369ae8)
2.  **Guardar:** Guarde na pasta `Transferências` (Downloads) ou `Documentos`.

**Credenciais da VM:**

| Campo           | Valor      |
|:----------------|:-----------|
| Nome de utilizador | `student`  |
| Palavra-passe   | `password` |

> **Nota sobre o formato:** Este ficheiro está no formato `.vdi` (nativo do VirtualBox).
>
> * **VirtualBox:** Use como está.
> * **VMware/UTM:** Pode precisar de convertê-lo ou instalar um ISO Debian limpo se a importação falhar (ver Apêndice A).

---

# Opção A: VirtualBox (Padrão para Windows/Mac Intel)

**Não use isto em Macs Apple Silicon (M1/M2/M3/M4). Use a Opção C (UTM).**

### 1. Instalação
1.  **Descarregar:** Vá a [virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).
2.  **Instalar Aplicação:** Descarregue e execute o instalador para o seu SO ("Windows hosts" ou "macOS / Intel hosts").
3.  **Instalar Extension Pack:** Descarregue o "Oracle VM VirtualBox Extension Pack" da mesma página e faça duplo clique para instalar.

### 2. Criar VM
1.  Abra o VirtualBox, clique em **Novo** (New).
    * **Nome:** `Debian LSS`
    * **Tipo:** `Linux` / **Versão:** `Debian (64-bit)`
2.  **RAM:** 4096 MB (4 GB) recomendado.
3.  **Disco Rígido:** Selecione **"Utilizar um Ficheiro de Disco Rígido Virtual Existente"**.
4.  Clique no ícone da pasta, navegue até ao ficheiro `.vdi` que descarregou e selecione-o.
5.  Clique em **Criar**.

### 3. Drivers (Guest Additions)
Os Guest Additions ativam a partilha de área de transferência, arrastar e largar, e o redimensionamento automático do ecrã.

1.  Inicie a VM e faça login com as credenciais acima.
2.  No menu da VM: **Dispositivos > Inserir imagem de CD dos Adicionais para Convidado...** (Devices > Insert Guest Additions CD image).
3.  Abra um terminal na VM e execute:

```bash
sudo apt update
sudo apt install build-essential dkms linux-headers-$(uname -r)
sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
sudo /mnt/cdrom/VBoxLinuxAdditions.run
sudo reboot
```

**Método alternativo** (mais simples, usa pacotes Debian):

```bash
sudo apt update
sudo apt install virtualbox-guest-utils virtualbox-guest-x11
sudo reboot
```

### 4. Verificar
Após o reinício, faça login e abra um terminal:

```bash
uname -a
```

Deverá ver uma versão do *kernel* Linux. Tente redimensionar a janela da VM; o ambiente de trabalho do convidado deverá redimensionar-se automaticamente.

---

# Opção B: VMware Workstation (Windows/Linux)

O VMware Workstation Pro é agora **gratuito para uso pessoal** e frequentemente oferece melhor desempenho que o VirtualBox.

### 1. Instalação
1.  **Descarregar:** Crie uma conta Broadcom e descarregue o **VMware Workstation Pro** (Windows) ou **VMware Fusion** (Mac -- apenas Intel).
2.  **Instalar:** Execute o instalador. Selecione "I want to license for Personal Use" (não é necessária chave).

### 2. Criar VM (Importar VDI)

O VMware usa o formato `.vmdk` nativamente. Pode tentar selecionar o `.vdi` escolhendo "Todos os Ficheiros", mas a conversão é mais segura (ver Apêndice A).

1.  Clique em **"Create a New Virtual Machine"** > **Custom (Advanced)**.
2.  **Guest OS:** Linux > Debian 12 (64-bit).
3.  **Disk:** Escolha **"Use an existing virtual disk"**.
4.  Procure o seu ficheiro `.vmdk` convertido (ou tente o `.vdi` diretamente).
5.  Quando for pedido para converter (**"Convert"**) o formato, clique em **Yes**.

### 3. Drivers (Open-VM-Tools)
O VMware usa drivers de código aberto que ativam a partilha de área de transferência, arrastar e largar, e o redimensionamento automático do ecrã.

1.  Inicie a VM e faça login com as credenciais acima.
2.  Abra um terminal e execute:

```bash
sudo apt update
sudo apt install open-vm-tools-desktop
sudo reboot
```

### 4. Verificar
Após o reinício, faça login e abra um terminal:

```bash
uname -a
```

Tente copiar texto entre o anfitrião e o convidado para confirmar que a integração da área de transferência funciona.

---

# Opção C: UTM (Mac Apple Silicon M1/M2/M3/M4)

**Esta é a única opção com bom desempenho para Macs modernos.**

### 1. Instalação
1.  Descarregue o **UTM** em [mac.getutm.app](https://mac.getutm.app/) (Grátis) ou na Mac App Store (Pago/Doação).
2.  **Importante:** O disco da aula é `.vdi` (arquitetura x86). Emular x86 em Apple Silicon é **lento**.
    * *Recomendação:* É altamente recomendado **instalar um Debian ARM64 limpo** em vez de usar o disco da aula.
    * *Se tiver de usar o disco da aula:* Precisa de convertê-lo para `.qcow2` primeiro (ver Apêndice A) e aceitar velocidades de emulação lentas.

### 2. Criar VM (Método de Instalação Limpa -- Recomendado)
1.  Descarregue o **ISO Debian ARM64** em [debian.org](https://www.debian.org/).
2.  Abra o UTM > **Create a New Virtual Machine**.
3.  **Virtualize** (Rápido) > **Linux**.
4.  **Boot Image:** Selecione o ISO Debian ARM64.
5.  Siga os passos do instalador. Use as mesmas credenciais que o disco da aula para consistência.

### 3. Drivers (SPICE Agent)
Para obter partilha de área de transferência e resolução dinâmica:

1.  Abra um terminal na VM.
2.  Execute:

```bash
sudo apt update
sudo apt install spice-vdagent
sudo reboot
```

### 4. Verificar
Após o reinício, faça login e abra um terminal:

```bash
uname -a
```

Deverá ver `aarch64` no resultado, confirmando a arquitetura ARM64.

---

# Opção D: Windows Subsystem for Linux (WSL)

Executa Linux nativamente ao lado do Windows. Alto desempenho, mas sem janela de ambiente de trabalho virtual por defeito.

### 1. Instalação
1.  Abra o **PowerShell** como Administrador.
2.  Execute:

```powershell
wsl --install
```

3.  **Reinicie** o seu computador.
4.  Após reiniciar, o "Ubuntu" abrirá. Crie um nome de utilizador e palavra-passe.

### 2. Manter o WSL Atualizado

Após a configuração inicial, garanta que o WSL e a distribuição estão atualizados:

```powershell
wsl --update
```

### 3. Otimizar Rede (Modo Espelhado)

Para fazer o WSL comportar-se como um PC real na sua rede (corrigindo muitos problemas de conectividade):

1.  No Windows, pressione `Win+R`, escreva `%UserProfile%` e prima Enter.
2.  Crie um ficheiro chamado `.wslconfig` (certifique-se de que não é `.wslconfig.txt`).
3.  Cole este conteúdo:

```ini
[wsl2]
networkingMode=mirrored
dnsTunneling=true
autoProxy=true
```

4.  Reinicie o WSL a partir do PowerShell: `wsl --shutdown`.

### 4. Aplicações Gráficas (GUI)
O WSL suporta aplicações gráficas de origem (via WSLg). Teste:

```bash
sudo apt update && sudo apt install mousepad thunar
mousepad
```

Uma janela de editor de texto deverá aparecer no seu ambiente de trabalho Windows.

### 5. Verificar

```bash
cat /etc/os-release
uname -r
```

Deverá ver a versão do Ubuntu e uma versão do *kernel* Linux contendo `WSL` ou `microsoft`.

---

# Pós-Configuração: Primeiros Passos Comuns

Independentemente da opção que escolheu, realize os seguintes passos no seu novo ambiente Linux.

### 1. Atualizar o Sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Ferramentas Essenciais

```bash
sudo apt install -y git curl wget vim nano net-tools
```

### 3. Configurar o Git

```bash
git config --global user.name "O Seu Nome"
git config --global user.email "o.seu.email@ua.pt"
```

### 4. Verificar que Tudo Funciona

```bash
echo "Olá a partir do Linux!"
uname -a
git --version
```

---

# Resolução de Problemas

### VT-x / AMD-V Não Ativado

**Sintoma:** O VirtualBox ou VMware falha ao iniciar a VM com um erro "VT-x is disabled" ou "AMD-V is not available".

**Solução:** Reinicie o computador, entre nas definições da BIOS/UEFI (geralmente pressionando `F2`, `F12`, `Del` ou `Esc` durante o arranque) e ative o **Intel VT-x** ou **AMD-V** (por vezes designado "SVM Mode") nas definições de CPU ou Segurança.

### Conflitos com Hyper-V no Windows

**Sintoma:** O VirtualBox reporta que o Hyper-V está ativo e o VT-x não pode ser utilizado.

**Solução:** O Hyper-V e o VirtualBox competem pela virtualização de *hardware*. Pode desativar o Hyper-V:

```powershell
bcdedit /set hypervisorlaunchtype off
```

Reinicie após executar este comando. Para reativar o Hyper-V posteriormente:

```powershell
bcdedit /set hypervisorlaunchtype auto
```

> **Nota:** Desativar o Hyper-V também desativa o WSL 2, o Windows Sandbox e o Credential Guard. Se necessitar dessas funcionalidades, considere usar o VMware ou o WSL em vez do VirtualBox.

### Rede Não Funciona na VM

**Sintoma:** A VM não tem acesso à internet.

**Solução:** Verifique as definições do adaptador de rede da VM:

* Certifique-se de que o adaptador está definido como **NAT** (o modo mais simples).
* Verifique se a máquina anfitriã tem acesso à internet.
* Dentro da VM, verifique o estado do adaptador: `ip addr show` e `ping -c 3 8.8.8.8`.
* Reinicie a rede: `sudo systemctl restart NetworkManager`.

### Problemas com Secure Boot

**Sintoma:** A VM falha ao arrancar ou os módulos do *kernel* (como os Guest Additions do VirtualBox) falham ao carregar.

**Solução:** Alguns sistemas requerem que o Secure Boot seja desativado na BIOS/UEFI para que os módulos de *kernel* de terceiros possam ser carregados. Desative-o nas definições da BIOS/UEFI no separador Segurança ou Arranque (*Boot*).

---

# Apêndice A: Converter o Disco (.vdi)

Se não estiver a usar o VirtualBox, pode precisar de converter o ficheiro `.vdi` descarregado.

### Para VMware (VDI para VMDK)

Requer que o VirtualBox esteja instalado (para o `VBoxManage`). Execute na Linha de Comandos (CMD):

```cmd
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" ^
  clonemedium disk "C:\Caminho\Para\Input.vdi" ^
  "C:\Caminho\Para\Output.vmdk" --format VMDK
```

### Para UTM (VDI para QCOW2)

Requer `qemu-img`. Instalar via Homebrew no macOS:

```bash
brew install qemu
qemu-img convert -f vdi -O qcow2 Input.vdi Output.qcow2
```

No Windows, o `qemu-img` está disponível instalando o QEMU para Windows, ou pode executar a conversão dentro do WSL:

```bash
sudo apt install qemu-utils
qemu-img convert -f vdi -O qcow2 /mnt/c/Caminho/Para/Input.vdi Output.qcow2
```
