---
title: Virtualização
subtitle: Laboratórios de Sistemas e Serviços
author: Mário Antunes
institute: Universidade de Aveiro
date: 23 de Fevereiro, 2026
colorlinks: true
geometry: a4paper,margin=2cm
mainfont: NotoSans
mainfontfallback:
  - "NotoColorEmoji:mode=harf"
header-includes:
 - \usepackage{longtable,booktabs}
 - \usepackage{etoolbox}
 - \AtBeginEnvironment{longtable}{\tiny}
 - \AtBeginEnvironment{cslreferences}{\tiny}
 - \AtBeginEnvironment{Shaded}{\normalsize}
 - \AtBeginEnvironment{verbatim}{\normalsize}
 - \setmonofont[Contextuals={Alternate}]{FiraCodeNerdFontMono-Retina}
---

# Exercícios

## Laboratório Prático: Explorar Virtualização e Emulação

Este guia irá acompanhá-lo através de diferentes formas de virtualização, desde a emulação ligeira até à gestão completa de servidores. Irá usar o **VirtualBox** (para Windows/macOS) ou o **QEMU** (para Linux) como a sua ferramenta principal.

-----

### Parte 1: Configuração do Anfitrião - A Sua Ferramenta de Virtualização

Primeiro, instale a ferramenta correta para o seu sistema operativo.

#### Para Anfitriões Windows e macOS: VirtualBox

1.  **Download e Instalação:**
      * Vá à [página de downloads do VirtualBox](https://www.virtualbox.org/wiki/Downloads) e descarregue o instalador para o seu SO.
      * Descarregue também o **VirtualBox Extension Pack** da mesma página.
      * Execute o instalador principal, aceitando as predefinições. No macOS, tem de **Permitir** a extensão de sistema da Oracle em `Definições do Sistema > Privacidade e Segurança`.
      * Dê um duplo clique no ficheiro do Extension Pack descarregado para o instalar.
2.  **Como Usar o VirtualBox:**
      * Irá usar a interface gráfica para criar e gerir VMs.
      * Clique em **"Novo"** para iniciar um assistente para uma nova VM.
      * Modifique as definições selecionando uma VM e clicando em **"Definições"**.

#### Para Anfitriões Linux: QEMU

1.  **Download e Instalação:**
      * O QEMU e o KVM (para aceleração de hardware) estão na maioria dos repositórios padrão. Em Debian/Ubuntu, abra um terminal e execute:
        ```bash
        $ sudo apt update
        $ sudo apt install qemu-system-x86 qemu-system-i386 bridge-utils
        ```
      * Adicione o seu utilizador ao grupo `kvm` para executar VMs sem `sudo`. Terá de fazer logout e login novamente para que esta alteração tenha efeito.
        ```bash
        $ sudo usermod -a -G kvm $USER
        ```
2.  **Como Usar o QEMU:**
      * O QEMU é controlado por linha de comandos. Irá criar discos com `qemu-img` e iniciar VMs com `qemu-system-x86_64`.
      * Um comando de arranque típico tem este aspeto, com flags a especificar os recursos:
        ```bash
        $ qemu-system-x86_64 -m 1G -hda imagem_disco.qcow2 -cdrom instalador.iso
        ```

-----

### Parte 2: Emulação Ligeira com FreeDOS 🕹️

Aqui, vamos explorar um SO simples e mono-tarefa para perceber a emulação básica de uma máquina.

1.  **Descarregar Recursos:**

      * Descarregue o **FreeDOS 1.3 Live CD** do [site oficial](https://www.freedos.org/download/). Vai precisar do ficheiro `FD14-LiveCD.zip` [aqui](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.4/FD14-LiveCD.zip).
        Extraia o ficheiro para obter o ficheiro `.iso`.
      * Descarregue um jogo clássico de DOS em formato shareware, como o primeiro episódio de **DOOM** (`doom19s.zip`), de um [arquivo](https://github.com/detiuaveiro/iei/blob/master/classes/class_03/02_support/01_freedos/games/doom19s.zip?raw=true) fidedigno.
        Extraia-o para uma pasta chamada `doom`.

2.  **Criar a VM FreeDOS:**

      * **VirtualBox:**
        1.  Clique em **"Novo"**. Nome: `FreeDOS`, Tipo: `Other`, Versão: `DOS`.
        2.  Memória: `64 MB`.
        3.  Disco Rígido: Criar um novo VDI, `128 MB`, tamanho fixo.
        4.  Em **Definições \> Armazenamento**, selecione a unidade de CD vazia, clique no ícone de CD à direita e **Escolha um ficheiro de disco...** para selecionar o seu `FD14LIVE.iso`.
      * **QEMU:**
        1.  Crie uma imagem de disco rígido de 128M.
            ```bash
            $ qemu-img create -f qcow2 freedos.qcow2 128M
            ```
        2.  Inicie a VM com o Live CD.
            ```bash
            $ qemu-system-i386 -machine accel=kvm:tcg -m 128 -cpu host \
            -k pt-pt -rtc base=localtime -device adlib -device sb16 \
            -device cirrus-vga -display gtk -hda $DISK \
            -cdrom /tmp/freedos/FD14LIVE.iso -boot d
            ```

3.  **Instalar e Configurar o FreeDOS:**

      * Arranque a VM e selecione "Install to harddisk".
      * Siga as instruções no ecrã. Será solicitado que particione e formate a unidade (`C:`). Prossiga com as opções padrão.
      * Após a conclusão da instalação, desligue a VM. No VirtualBox, remova o ISO da unidade de CD virtual. No QEMU, remova as flags `-cdrom` e `-boot d` para o próximo arranque.

4.  **Colocar o Jogo na VM:**
    Vamos criar uma segunda imagem de CD contendo o jogo.

      * **No Linux:** O Qemu pode criar uma unidade FAT a partir de uma pasta.
      * **No Windows/macOS:** Use uma ferramenta gratuita como o AnyBurn para "Create ISO from files/folders".
      * **Anexar o ISO do jogo:**
          * **VirtualBox:** Vá a **Definições \> Armazenamento**. Clique no ícone "Adicionar Unidade Ótica" no Controlador IDE e, em seguida, adicione o seu `doom.iso`.
          * **QEMU:** Adicione uma segunda unidade ao seu comando de arranque: `-drive file=fat:rw:/tmp/games/doom,format=raw`.
      * **Inicie o FreeDOS.** O seu CD de jogo aparecerá provavelmente como a unidade `D:`. Escreva `D:` para mudar para essa unidade e, em seguida, execute `INSTALL.BAT` ou o ficheiro `.EXE` do jogo.

5.  **Jogar o Jogo**

-----

### Parte 3: Virtualização Ligeira com Alpine Linux 🏔️

Vamos instalar uma distribuição Linux moderna e mínima que é a base para muitos contentores.

1.  **Descarregar o Alpine:**

      * Vá à [página de downloads do Alpine Linux](https://alpinelinux.org/downloads/) e obtenha a versão **STANDARD** para a sua arquitetura (geralmente x86\_64 ou aarch64 ISO).

2.  **Instalar o Alpine:**

      * **VirtualBox:**
        1.  Crie uma nova VM. Nome: `Alpine`, Tipo: `Linux`, Versão: `Linux 2.6 / 3.x / 4.x (64-bit)`.
        2.  Memória: `1G`. Disco Rígido: `8 GB`.
        3.  Anexe o ISO do Alpine em **Definições \> Armazenamento**.
      * **QEMU:**
        ```bash
        $ qemu-img create -f qcow2 alpine.qcow2 8G
        $ qemu-system-x86_64 -m 1G -hda alpine.qcow2 -cdrom caminho/para/alpine.iso -boot d
        ```
      * Arranque a VM e faça login como `root` (sem password). Execute `setup-alpine` e siga as instruções. Uma instalação do tipo "sys" em `sda` é uma boa escolha. Quando terminar, reinicie e remova o ISO.

3.  **Explorar Tipos de Rede:**

      * **NAT (Padrão):** Com a configuração de rede padrão, inicie a VM и verifique o seu endereço IP.
        ```bash
        # Dentro da VM Alpine
        $ ip addr show
        ```
        Verá um IP como `10.0.2.15`. Consegue aceder à internet (p. ex., `ping google.com`), mas não consegue aceder facilmente à VM a partir do seu anfitrião.
      * **Bridge:** Desligue a VM.
          * **VirtualBox:** Vá a **Definições \> Rede**. Mude **Ligada a:** de `NAT` para `Placa em modo Bridge (Bridged Adapter)`.
          * **QEMU:** Modifique o seu comando de arranque para usar uma bridge. Isto é mais complexo e dependente do sistema.
            Aqui está um exemplo de código:
        <!-- end list -->
        ```bash
        echo -e "Configurar Interface Bridge"
        sudo /sbin/ip link add virtbr0 type bridge
        sudo /sbin/ip link set dev $INTERFACE master virtbr0
        sudo /sbin/ip addr flush dev $INTERFACE
        sudo /sbin/dhclient virtbr0
        sudo /sbin/ip link set dev $INTERFACE up
        sudo /sbin/ip link set dev virtbr0 up

        echo -e "Iniciar Alpine (BRIDGE)"
        sudo qemu-system-x86_64 -machine accel=kvm:tcg -m 4G -smp 4 -cpu host \
        -k pt-pt -rtc base=localtime -display gtk -hda $DISK \
        -netdev bridge,id=net0,br=virtbr0 -device virtio-net-pci,netdev=net0

        echo -e "Limpar Interface Bridge"
        sudo /sbin/ip link set virtbr0 down
        sudo /sbin/ip link del virtbr0
        sudo /sbin/dhclient $INTERFACE
        ```
      * Inicie a VM novamente e execute `ip addr show`. Deverá ver agora um endereço IP da sua rede doméstica local (p. ex., `192.168.1.123`).

4.  **Configurar um Servidor Web:**

      * O Alpine usa o `busybox httpd`. Instale o pacote para funcionalidades extra.
        ```bash
        # Dentro da VM Alpine
        $ apk add busybox-extras
        ```
      * Crie um diretório para a sua página web.
        ```bash
        $ mkdir -p /var/www/localhost/htdocs
        ```
      * Crie uma página HTML simples.
        ```bash
        $ echo '<h1>Olá do Alpine Linux!</h1>' > /var/www/localhost/htdocs/index.html
        ```
      * Inicie o servidor web.
        ```bash
        $ httpd -f -p 80 -h /var/www/localhost/htdocs
        ```
      * A partir do **navegador web da sua máquina anfitriã**, navegue até ao endereço IP da VM Alpine. Deverá ver a sua mensagem\!

-----

### Parte 4: Gestão de Servidores com Proxmox VE 🖥️

Vamos virtualizar o virtualizador\! Iremos instalar o Proxmox, um hipervisor bare-metal, dentro de uma VM.

> **⚠️ CUIDADO: Virtualização Aninhada (Nested Virtualization)**
> Está prestes a executar um hipervisor (Proxmox) dentro de outro hipervisor (VirtualBox/QEMU). Isto chama-se **virtualização aninhada**. É muito exigente para a sua CPU e será lento. Este exercício é apenas para fins de demonstração.

1.  **Descarregar o Proxmox:**

      * Vá à [página de downloads do Proxmox VE](https://www.proxmox.com/en/downloads) e obtenha o Instalador ISO mais recente.

2.  **Criar a VM Proxmox:**
    Esta VM precisa de mais recursos.

      * **VirtualBox:**
        1.  Crie uma VM. Nome: `Proxmox`, Tipo: `Linux`, Versão: `Debian (64-bit)`.
        2.  Memória: `4096 MB` ou mais. Processadores: `2` ou mais.
        3.  Disco Rígido: `32 GB` ou mais.
        4.  Em **Definições \> Sistema \> Processador**, marque a opção **Ativar VT-x/AMD-V Aninhado**.
        5.  Em **Definições \> Rede**, defina para `NAT`.
        6.  Configure o encaminhamento de portas para redirecionar a porta 8006 do Anfitrião para a porta 8006 do Convidado.
        7.  Anexe o ISO do Proxmox.
      * **QEMU:**
        ```bash
        $ qemu-img create -f qcow2 proxmox.qcow2 32G
        # A flag '-cpu host' é crítica para passar as capacidades de virtualização
        $ qemu-system-x86_64 -m 4096 -smp 2 -cpu host -hda proxmox.qcow2 -cdrom proxmox.iso -boot d -net nic -net user,hostfwd=tcp::8006-:8006
        ```

3.  **Instalar e Configurar:**

      * Arranque a VM e siga os passos de instalação do Proxmox. É um instalador gráfico padrão.
      * Para a rede, forneça um IP estático na sua rede doméstica (p. ex., `192.168.1.200`).
      * Após a instalação, reinicie e remova o ISO.

4.  **Aceder ao Portal Web:**

      * Na consola do Proxmox, será exibido o URL de acesso. A partir do **navegador web da sua máquina anfitriã**, navegue para `https://localhost:8006`.
      * Verá um aviso de segurança sobre o certificado; é seguro prosseguir.
      * Faça login com `root` e a password que definiu durante a instalação.

5.  **Iniciar uma VM Convidada no Proxmox:**

      * Dentro do portal web do Proxmox, pode agora criar uma nova VM ou contentor.
      * Desafio: Tente criar uma nova **VM Alpine Linux** dentro do Proxmox, carregando o ISO do Alpine para o servidor Proxmox e seguindo as instruções da interface web.

-----

### Parte 5: Exercício Bónus - Emular o SO Android 🤖

A melhor forma de emular o Android é usando as ferramentas oficiais da Google.

1.  **Download e Instalação do Android Studio:**

      * Vá à [página de download do Android Studio](https://developer.android.com/studio) e obtenha o instalador para o seu SO.
      * O processo de instalação é um assistente padrão. Irá descarregar muitos componentes, por isso levará algum tempo.

2.  **Usar o AVD Manager:**

      * Abra o Android Studio. Não precisa de criar um projeto.
      * No ecrã de boas-vindas ou no menu **Tools**, selecione **AVD Manager** (Android Virtual Device Manager).

3.  **Criar um Dispositivo Virtual:**

      * Clique em **"Create Virtual Device..."**.
      * Escolha um perfil de hardware de telemóvel (p. ex., Pixel 7).
      * Selecione uma imagem de sistema (uma versão do Android) para descarregar.
      * Dê um nome ao seu AVD e clique em **Finish**.

4.  **Iniciar o Emulador:**

      * De volta ao AVD Manager, clique no ícone "Play" ao lado do seu novo dispositivo virtual.
      * Uma nova janela abrirá, arrancando um sistema operativo Android completo e emulado. Explore a interface, abra aplicações e use o navegador, tal como num telemóvel real.
