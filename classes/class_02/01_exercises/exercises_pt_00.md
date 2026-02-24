---
title: Virtualização
---

# Exercícios

## Laboratório Prático: Explorar Virtualização e Emulação

Este guia irá acompanhá-lo através de diferentes formas de virtualização, desde a emulação ligeira até à gestão completa de servidores. Irá usar o **VirtualBox** (para Windows/macOS) ou o **QEMU** (para Linux) como a sua ferramenta principal.

> **Antes de começar:** Certifique-se de que tem pelo menos **50 GB de espaço livre em disco** e uma ligação estável à internet. Alguns downloads são grandes e as imagens de disco das VMs podem crescer rapidamente.



### Parte 1: Configuração do Anfitrião -- A Sua Ferramenta de Virtualização

Primeiro, instale a ferramenta correta para o seu sistema operativo.

#### Para Anfitriões Windows e macOS: VirtualBox

1.  **Descarregar o Instalador:**
      * Vá à [página de downloads do VirtualBox](https://www.virtualbox.org/wiki/Downloads) e descarregue o instalador para o seu SO (Windows ou macOS).
      * Descarregue também o **VirtualBox Extension Pack** da mesma página (é um ficheiro único que funciona para todas as plataformas).

2.  **Instalar o VirtualBox:**
      * **Windows:** Execute o instalador `.exe`. Aceite as opções predefinidas. O Windows pode pedir-lhe para aprovar a instalação de drivers de rede --- clique **Sim**.
      * **macOS:** Abra o ficheiro `.dmg` e execute o instalador. **Tem de** ir a `Definições do Sistema > Privacidade e Segurança` e clicar **Permitir** para aprovar a extensão de sistema da Oracle. Pode ser necessário reiniciar.

3.  **Instalar o Extension Pack:**
      * Abra o VirtualBox. Vá a **Ficheiro > Ferramentas > Gestor de Extension Packs** (ou **Preferências > Extensões** em versões mais antigas).
      * Clique no ícone **Instalar** e selecione o ficheiro do Extension Pack que descarregou.
      * Aceite o acordo de licença.

4.  **Verificar a Instalação:**
      * Abra o VirtualBox. Deverá ver a janela principal do gestor com uma lista de VMs vazia.
      * Vá a **Ajuda > Sobre o VirtualBox** e confirme que o número da versão corresponde ao da versão do Extension Pack.
      * Se aparecerem avisos sobre drivers ou módulos do kernel, siga as instruções no ecrã antes de prosseguir.

#### Para Anfitriões Linux: QEMU/KVM

1.  **Instalar Pacotes:**
      * Em Debian/Ubuntu, abra um terminal e execute:
        ```bash
        $ sudo apt update
        $ sudo apt install qemu-system-x86 qemu-system-i386 qemu-utils bridge-utils
        ```
      * Em Fedora:
        ```bash
        $ sudo dnf install qemu-system-x86 qemu-img bridge-utils
        ```

2.  **Ativar o Acesso ao KVM:**
      * Adicione o seu utilizador ao grupo `kvm` para poder executar VMs sem `sudo`:
        ```bash
        $ sudo usermod -a -G kvm $USER
        ```
      * **Importante:** Tem de fazer logout e login novamente (ou reiniciar) para que a alteração ao grupo tenha efeito.

3.  **Verificar a Instalação:**
      * Verifique se o KVM está disponível:
        ```bash
        $ kvm-ok
        ```
        Deverá ver: `KVM acceleration can be used`. Se não, poderá ter de ativar Intel VT-x ou AMD-V nas definições da BIOS/UEFI.
      * Confirme que o QEMU está instalado:
        ```bash
        $ qemu-system-x86_64 --version
        ```
        Deverá ser apresentado o número de versão do QEMU.



### Parte 2: Emulação Ligeira com FreeDOS

Neste exercício exploramos um sistema operativo simples e mono-tarefa (FreeDOS) para compreender a emulação básica de uma máquina. O FreeDOS é uma implementação open-source do MS-DOS e pode executar software clássico de DOS, incluindo jogos.

#### Passo 1 -- Descarregar Recursos

1.  Descarregue o **FreeDOS 1.4 Live CD** do [site oficial](https://www.freedos.org/download/). Precisa do ficheiro `FD14-LiveCD.zip` [aqui](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.4/FD14-LiveCD.zip).
2.  Extraia o ficheiro ZIP. No interior encontrará o ficheiro `FD14LIVE.iso`.
3.  Descarregue a versão shareware do **DOOM** (`doom19s.zip`) deste [arquivo](https://github.com/detiuaveiro/iei/blob/master/classes/class_03/02_support/01_freedos/games/doom19s.zip?raw=true).
4.  Extraia `doom19s.zip` para uma pasta chamada `doom/` na sua máquina anfitriã.

#### Passo 2 -- Criar a Máquina Virtual FreeDOS

**VirtualBox:**

1.  Abra o VirtualBox e clique em **Novo**.
2.  Configure a VM:
      * **Nome:** `FreeDOS`
      * **Tipo:** `Other`
      * **Versão:** `DOS`
3.  Defina a **Memória** para `64 MB`. (O DOS não precisa de mais.)
4.  Para o **Disco Rígido**, escolha *Criar um disco rígido virtual agora*:
      * **Tipo de ficheiro:** VDI
      * **Tamanho:** `512 MB`
      * Escolha **Tamanho fixo** para melhor desempenho.
5.  Clique em **Criar** para terminar o assistente.
6.  Com a nova VM `FreeDOS` selecionada, clique em **Definições > Armazenamento**.
7.  Em **Controlador: IDE**, clique no ícone do disco **Vazio**.
8.  No lado direito, clique no pequeno ícone de CD e escolha **Escolher um ficheiro de disco...**.
9.  Selecione o ficheiro `FD14LIVE.iso` que extraiu anteriormente.
10. Clique em **OK** para guardar.

**QEMU (Linux):**

1.  Crie uma imagem de disco de 500 MB:
    ```bash
    $ qemu-img create -f qcow2 freedos.qcow2 500M
    ```
2.  Inicie a VM com o Live CD anexado:
    ```bash
    $ qemu-system-i386 -machine accel=kvm:tcg -m 128 -cpu host \
        -k pt -rtc base=localtime \
        -device adlib -device sb16 \
        -device cirrus-vga -display gtk \
        -hda freedos.qcow2 \
        -cdrom FD14LIVE.iso -boot d
    ```

> **Nota:** As flags `-device adlib -device sb16` emulam placas de som clássicas para que os jogos de DOS possam produzir áudio.

#### Passo 3 -- Instalar o FreeDOS

1.  Arranque a VM. Verá o menu de arranque do FreeDOS.
2.  Selecione **Install to harddisk**.
3.  Siga as instruções no ecrã:
      * Quando for solicitado para particionar o disco, aceite a predefinição (usar o disco todo para `C:`).
      * Quando for solicitado para formatar, confirme **Sim** (formato FAT32).
      * Selecione os pacotes que deseja instalar (as predefinições são adequadas).
4.  Aguarde que a instalação termine. Será pedido que reinicie.
5.  **Antes de reiniciar, remova o ISO:**
      * **VirtualBox:** Vá a **Definições > Armazenamento**, clique no ISO sob o controlador IDE, clique no ícone de CD à direita e escolha **Remover disco da unidade virtual**. Em seguida, reinicie a VM.
      * **QEMU:** Feche a janela do QEMU. Re-inicie sem `-cdrom` e `-boot d`:
        ```bash
        $ qemu-system-i386 -machine accel=kvm:tcg -m 128 -cpu host \
            -k pt -rtc base=localtime \
            -device adlib -device sb16 \
            -device cirrus-vga -display gtk \
            -hda freedos.qcow2 -boot c
        ```
6.  **Verificar:** A VM deverá arrancar no FreeDOS a partir do disco rígido e apresentar o prompt `C:\>`.

#### Passo 4 -- Transferir o Jogo para a VM

Como o FreeDOS não tem pilha de rede por predefinição, vamos usar uma unidade virtual para transferir ficheiros.

**VirtualBox:**

1.  Use uma ferramenta gratuita como o **AnyBurn** (Windows) ou **Brasero** (Linux) para criar um ficheiro ISO a partir da sua pasta `doom/`. Nomeie-o `doom.iso`.
2.  No VirtualBox, vá a **Definições > Armazenamento** da VM FreeDOS.
3.  Clique no ícone **Adicionar Unidade Ótica** no Controlador IDE e selecione o seu `doom.iso`.
4.  Inicie a VM. O ISO aparecerá como unidade `D:`.

**QEMU (Linux):**

O QEMU pode expor uma pasta do anfitrião como uma unidade FAT virtual. Adicione esta flag ao iniciar a VM:

```bash
$ qemu-system-i386 -machine accel=kvm:tcg -m 128 -cpu host \
    -k pt -rtc base=localtime \
    -device adlib -device sb16 \
    -device cirrus-vga -display gtk \
    -hda freedos.qcow2 -boot c \
    -drive file=fat:rw:doom/,format=raw
```

O conteúdo da pasta `doom/` aparecerá como unidade `D:` dentro do FreeDOS.

#### Passo 5 -- Instalar e Executar o Jogo

1.  No prompt do FreeDOS, mude para a unidade do jogo:
    ```
    C:\> D:
    D:\> dir
    ```
    Deverá ver os ficheiros do DOOM listados.
2.  Copie os ficheiros para o disco rígido (opcional mas recomendado):
    ```
    D:\> mkdir C:\DOOM
    D:\> copy *.* C:\DOOM
    ```
3.  Execute o jogo:
    ```
    D:\> DOOM.EXE
    ```
    Ou, se copiou:
    ```
    C:\> cd DOOM
    C:\DOOM> DOOM.EXE
    ```
4.  **Verificar:** Deverá ver o ecrã de título do DOOM e ouvir efeitos sonoros através das placas de som emuladas. Use as teclas de setas e `Ctrl` para jogar.

#### Passo 6 -- Reflexão

Responda a estas perguntas nas suas notas de laboratório:

* Que tipo de virtualização está a ser usado aqui (emulação, virtualização completa ou paravirtualização)?
* Porque é que o FreeDOS só precisa de 64 MB de RAM?
* Qual é o papel da flag `-device sb16`? O que acontece se a remover?



### Parte 3: Virtualização Ligeira com Alpine Linux

O Alpine Linux é uma distribuição Linux leve e orientada para segurança. É amplamente usada como imagem base para contentores Docker. Neste exercício irá instalá-lo numa VM, explorar modos de rede e configurar um servidor web.

#### Passo 1 -- Descarregar o ISO

1.  Vá à [página de downloads do Alpine Linux](https://alpinelinux.org/downloads/).
2.  Descarregue a imagem **Standard** para a sua arquitetura:
      * A maioria dos PCs: `x86_64`
      * Macs com Apple Silicon: `aarch64`
3.  Anote o nome do ficheiro descarregado (p. ex., `alpine-standard-3.22.1-x86_64.iso`).

#### Passo 2 -- Criar a VM Alpine

**VirtualBox:**

1.  Abra o VirtualBox e clique em **Novo**.
2.  Configure a VM:
      * **Nome:** `Alpine`
      * **Tipo:** `Linux`
      * **Versão:** `Other Linux (64-bit)`
3.  Defina a **Memória** para `1024 MB` (1 GB).
4.  Para o **Disco Rígido**, crie um novo VDI com **8 GB** (dinamicamente alocado é adequado).
5.  Clique em **Criar**.
6.  Vá a **Definições > Armazenamento** e anexe o ISO do Alpine à unidade de CD vazia (tal como fez para o FreeDOS).
7.  Clique em **OK**.

**QEMU (Linux):**

1.  Crie uma imagem de disco de 8 GB:
    ```bash
    $ qemu-img create -f qcow2 alpine.qcow2 8G
    ```
2.  Inicie a VM com o ISO:
    ```bash
    $ qemu-system-x86_64 -machine q35,accel=kvm:tcg \
        -m 1G -smp 2 -cpu host \
        -k pt -rtc base=localtime -display gtk \
        -drive file=alpine.qcow2,format=qcow2,if=virtio \
        -cdrom alpine-standard-3.22.1-x86_64.iso -boot d \
        -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80
    ```

> **Nota:** A flag `-nic user,...,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80` configura a rede NAT e redireciona a porta 2222 do anfitrião para a porta 22 do convidado (SSH) e a porta 8080 do anfitrião para a porta 80 do convidado (HTTP).

#### Passo 3 -- Instalar o Alpine Linux

1.  Arranque a VM. Após alguns segundos verá um prompt de login.
2.  Faça login como `root` (sem password na imagem live).
3.  Execute o instalador:
    ```bash
    # setup-alpine
    ```
4.  Siga as instruções cuidadosamente:
      * **Layout do teclado:** Escolha o seu layout (p. ex., `pt` para Português).
      * **Hostname:** Aceite a predefinição (`alpine`) ou escolha o seu próprio.
      * **Rede:** Selecione a interface detetada (geralmente `eth0`). Escolha `dhcp` para IP automático.
      * **Password de root:** Defina uma password que se lembre (p. ex., `student`).
      * **Fuso horário:** Escolha o seu fuso horário (p. ex., `Europe/Lisbon`).
      * **Proxy:** Prima Enter para saltar (nenhum).
      * **Mirror:** Escreva um número ou prima `f` para autodetetar o mirror mais rápido.
      * **Servidor SSH:** Escolha `openssh`.
      * **Disco:** Escreva `sda` (ou `vda` se estiver a usar virtio).
      * **Tipo de instalação:** Escolha `sys` (instalação completa no disco).
      * **Apagar disco:** Confirme com `y`.
5.  Aguarde que a instalação termine.
6.  Quando terminar, escreva `poweroff` para desligar a VM.
7.  **Remova o ISO:**
      * **VirtualBox:** Vá a **Definições > Armazenamento**, selecione o ISO e remova-o da unidade.
      * **QEMU:** Re-inicie sem as flags `-cdrom` e `-boot d`.

#### Passo 4 -- Arrancar e Verificar

1.  Inicie a VM novamente (sem o ISO).
2.  Faça login como `root` com a password que definiu.
3.  Verifique a conectividade de rede:
    ```bash
    # ip addr show
    # ping -c 3 google.com
    ```
4.  **Verificar a partir do anfitrião:** Abra um terminal na máquina anfitriã e tente:
      * **Utilizadores QEMU:** `ssh root@localhost -p 2222`
      * **Utilizadores VirtualBox NAT:** Precisa de configurar o reencaminhamento de portas primeiro (ver Passo 5).

#### Passo 5 -- Explorar Modos de Rede

**Compreender o NAT (predefinição):**

Com NAT, a VM consegue aceder à internet através do anfitrião, mas o anfitrião não consegue aceder diretamente à VM. A VM obtém um IP privado (geralmente `10.0.2.15`).

Para aceder à VM a partir do anfitrião em modo NAT, tem de configurar o **reencaminhamento de portas**:

* **VirtualBox:** Vá a **Definições > Rede > Avançado > Reencaminhamento de Portas**. Adicione duas regras:

  | Nome | Protocolo | Porta Anfitrião | Porta Convidado |
  |------|-----------|-----------------|-----------------|
  | SSH  | TCP       | 2222            | 22              |
  | HTTP | TCP       | 8080            | 80              |

  Agora, a partir do anfitrião pode executar:
  ```bash
  $ ssh root@localhost -p 2222
  ```

* **QEMU:** O reencaminhamento de portas já foi configurado no comando de arranque com `hostfwd=tcp::2222-:22`.

**Mudar para Modo Bridge:**

Com uma rede bridge, a VM obtém o seu próprio endereço IP da sua rede local (p. ex., `192.168.1.x`), como se fosse outro computador físico na rede.

1.  Desligue a VM.
2.  **VirtualBox:** Vá a **Definições > Rede**. Mude **Ligada a:** de `NAT` para `Placa em modo Bridge (Bridged Adapter)`. Selecione a interface de rede do anfitrião no dropdown.
3.  **QEMU:** Isto requer a criação de uma bridge de rede no anfitrião, o que necessita de acesso root. Consulte o script `alpine.sh` fornecido nos materiais de suporte para um exemplo funcional.
4.  Inicie a VM e verifique o novo IP:
    ```bash
    # ip addr show eth0
    ```
    Deverá ver um IP da sua rede local (p. ex., `192.168.1.123`).
5.  A partir do anfitrião, pode agora aceder diretamente à VM:
    ```bash
    $ ssh root@192.168.1.123
    ```

**Verificar a diferença:** Note como com NAT precisou de reencaminhamento de portas (`localhost:2222`), mas com modo bridge liga-se diretamente ao IP da VM.

#### Passo 6 -- Configurar um Servidor Web

1.  Certifique-se de que a VM está a funcionar e está logado como `root`.
2.  Atualize o índice de pacotes e instale um servidor web leve:
    ```bash
    # apk update
    # apk add lighttpd
    ```
3.  Crie uma página HTML simples:
    ```bash
    # mkdir -p /var/www/localhost/htdocs
    # cat > /var/www/localhost/htdocs/index.html << 'EOF'
    <!DOCTYPE html>
    <html>
    <head><title>Alpine VM</title></head>
    <body>
      <h1>Olá do Alpine Linux!</h1>
      <p>Esta página é servida a partir de uma máquina virtual.</p>
    </body>
    </html>
    EOF
    ```
4.  Inicie o servidor web:
    ```bash
    # rc-service lighttpd start
    ```
5.  Verifique dentro da VM:
    ```bash
    # wget -qO- http://localhost
    ```
    Deverá ver o conteúdo HTML que acabou de criar.
6.  **Aceder a partir da máquina anfitriã:**
      * **Modo NAT (VirtualBox com reencaminhamento de portas ou QEMU):** Abra o navegador web e navegue para `http://localhost:8080`.
      * **Modo Bridge:** Navegue para `http://<IP_DA_VM>` (p. ex., `http://192.168.1.123`).
7.  **Verificar:** Deverá ver a página "Olá do Alpine Linux!" no seu navegador.

#### Passo 7 -- Ativar o Servidor Web no Arranque (Opcional)

Para que o servidor web inicie automaticamente quando a VM arranca:

```bash
# rc-update add lighttpd default
```

Reinicie a VM e verifique que a página ainda está acessível sem iniciar manualmente o serviço.

#### Passo 8 -- Reflexão

Responda a estas perguntas nas suas notas de laboratório:

* Que tipo de virtualização está o Alpine a usar (emulação ou virtualização completa)?
* Qual é a diferença entre rede NAT e Bridge? Quando usaria cada uma?
* Porque é que o Alpine Linux é tão popular para contentores e VMs?
* Qual é o tamanho do ISO do Alpine comparado com um ISO típico do Ubuntu ou Windows?



### Parte 4: Gestão de Servidores com Proxmox VE

O Proxmox Virtual Environment (VE) é uma plataforma profissional e open-source de virtualização de servidores. Combina KVM (para VMs) e LXC (para contentores) com uma interface de gestão web. Neste exercício irá instalar o Proxmox dentro de uma VM para explorar as suas capacidades.

> **Cuidado: Virtualização Aninhada.**
> Irá executar um hipervisor (Proxmox) dentro de outro hipervisor (VirtualBox/QEMU). Isto chama-se **virtualização aninhada**. É muito exigente em termos de recursos e será lento. Este exercício é para fins de aprendizagem.

#### Passo 1 -- Descarregar o Proxmox

1.  Vá à [página de downloads do Proxmox VE](https://www.proxmox.com/en/downloads).
2.  Descarregue o mais recente **Proxmox VE ISO Installer** (terá aproximadamente 1,2 GB).

#### Passo 2 -- Criar a VM Proxmox

Esta VM precisa de significativamente mais recursos do que os exercícios anteriores.

**VirtualBox:**

1.  Clique em **Novo** e configure:
      * **Nome:** `Proxmox`
      * **Tipo:** `Linux`
      * **Versão:** `Debian (64-bit)`
2.  Defina a **Memória** para `4096 MB` (4 GB) ou mais.
3.  Defina **Processadores** para `2` ou mais.
4.  Crie um disco rígido de pelo menos **32 GB** (dinamicamente alocado).
5.  Antes de iniciar, vá a **Definições** e aplique estas alterações:
      * **Sistema > Processador:** Marque **Ativar VT-x/AMD-V Aninhado** (isto permite ao Proxmox executar VMs dentro de si mesmo).
      * **Rede > Adaptador 1:** Defina **Ligada a:** `NAT`.
      * **Rede > Adaptador 1 > Avançado > Reencaminhamento de Portas:** Adicione uma regra:

        | Nome    | Protocolo | Porta Anfitrião | Porta Convidado |
        |---------|-----------|-----------------|-----------------|
        | WebUI   | TCP       | 8006            | 8006            |

      * **Armazenamento:** Anexe o ISO do Proxmox à unidade de CD.
6.  Clique em **OK** para guardar todas as definições.

**QEMU (Linux):**

1.  Crie uma imagem de disco de 32 GB:
    ```bash
    $ qemu-img create -f qcow2 proxmox.qcow2 32G
    ```
2.  Inicie a VM para instalação:
    ```bash
    $ qemu-system-x86_64 -machine q35,accel=kvm:tcg \
        -m 4G -smp 2 -cpu host \
        -k pt -rtc base=localtime -display gtk \
        -drive file=proxmox.qcow2,format=qcow2,if=virtio \
        -cdrom proxmox-ve.iso -boot d \
        -nic user,model=virtio-net-pci,hostfwd=tcp::8006-:8006
    ```

> **Nota:** A flag `-cpu host` é crítica. Passa as capacidades de virtualização da CPU do anfitrião (VT-x/AMD-V) para o convidado, que o Proxmox necessita para criar VMs aninhadas.

#### Passo 3 -- Instalar o Proxmox

1.  Arranque a VM. O instalador gráfico do Proxmox será iniciado.
2.  Clique em **Install Proxmox VE**.
3.  Aceite o acordo de licença (EULA).
4.  Selecione o disco rígido alvo (a única opção deverá ser o seu disco virtual).
5.  Defina o seu país, fuso horário e layout de teclado.
6.  Defina a **password de root** (lembre-se dela!) e introduza um endereço de email (pode ser fictício para fins de laboratório, p. ex., `admin@lab.local`).
7.  **Configuração de rede:**
      * **Hostname:** `proxmox.lab.local`
      * **Endereço IP:** Use o endereço sugerido pelo instalador (geralmente `10.0.2.15/24` em modo NAT).
      * **Gateway:** `10.0.2.2` (gateway NAT predefinido do QEMU/VirtualBox).
      * **DNS:** `10.0.2.3` ou `8.8.8.8`.
8.  Reveja o resumo e clique em **Install**.
9.  Aguarde que a instalação termine (5-10 minutos).
10. Quando solicitado, clique em **Reboot**.
11. **Remova o ISO** da unidade virtual antes que o reinício termine.

#### Passo 4 -- Aceder à Interface Web do Proxmox

1.  Após o reinício, a consola do Proxmox apresentará um URL como:
    ```
    https://10.0.2.15:8006/
    ```
2.  Como configurámos o reencaminhamento de portas, abra o **navegador web da máquina anfitriã** e navegue para:
    ```
    https://localhost:8006
    ```
3.  Verá um aviso de segurança sobre o certificado autoassinado. Isto é esperado --- clique em **Avançado** e depois em **Prosseguir** (ou **Aceitar o risco**).
4.  Faça login com:
      * **Utilizador:** `root`
      * **Realm:** `Linux PAM standard authentication`
      * **Password:** a password que definiu durante a instalação.
5.  **Verificar:** Deverá ver o painel de controlo do Proxmox com o seu nó listado no lado esquerdo, mostrando utilização de CPU, memória e armazenamento.

#### Passo 5 -- Explorar a Interface do Proxmox

Dedique alguns minutos a explorar:

1.  Clique no nome do seu nó (p. ex., `proxmox`) na barra lateral esquerda.
2.  Examine o separador **Summary**: utilização de CPU, RAM, uptime.
3.  Vá a **Datacenter > Storage**: veja o armazenamento predefinido (`local` e `local-lvm`).
4.  Vá a **Datacenter > Network**: veja as interfaces de rede configuradas.

#### Passo 6 -- Criar uma VM Convidada dentro do Proxmox (Desafio)

Este é um objetivo avançado. Tente criar uma VM Alpine Linux dentro do Proxmox:

1.  **Carregar o ISO do Alpine:** Na interface web do Proxmox, vá ao seu nó > **local (storage)** > **ISO Images** > **Upload**. Carregue o ISO do Alpine que descarregou anteriormente.
2.  **Criar uma VM:** Clique no botão **Create VM** no canto superior direito.
      * **General:** Dê-lhe um nome (p. ex., `alpine-nested`).
      * **OS:** Selecione o ISO do Alpine carregado.
      * **System:** Aceite as predefinições.
      * **Disks:** Defina o tamanho do disco para `2 GB`.
      * **CPU:** `1 core`.
      * **Memory:** `512 MB`.
3.  Clique em **Finish**, depois selecione a nova VM e clique em **Start**.
4.  Abra o separador **Console** para ver o processo de arranque do Alpine.
5.  **Verificar:** Consegue fazer login como `root` na VM Alpine aninhada? Consegue aceder à internet?

> **Nota:** As VMs aninhadas serão muito lentas devido à sobrecarga da dupla virtualização. Este é o comportamento esperado.

#### Passo 7 -- Reflexão

Responda a estas perguntas nas suas notas de laboratório:

* Qual é a diferença entre um hipervisor Tipo 1 e Tipo 2? De que tipo é o Proxmox?
* Porque precisámos de ativar "VT-x/AMD-V Aninhado" no VirtualBox?
* Que vantagens oferece uma interface de gestão web em relação a ferramentas de linha de comandos?
* Poderia usar o Proxmox num ambiente de produção? O que seria diferente desta configuração de laboratório?



### Parte 5: Bónus -- Emular o Android

A melhor forma de emular o Android num PC é usando as ferramentas oficiais da Google.

#### Passo 1 -- Instalar o Android Studio

1.  Vá à [página de download do Android Studio](https://developer.android.com/studio).
2.  Descarregue e instale a versão para o seu SO.
3.  O instalador irá descarregar componentes adicionais (SDK, imagens do emulador). Isto pode demorar **15-30 minutos** dependendo da sua ligação.

#### Passo 2 -- Criar um Dispositivo Virtual

1.  Abra o Android Studio. **Não** precisa de criar um projeto.
2.  No ecrã de boas-vindas, clique em **More Actions > Virtual Device Manager** (ou no menu **Tools** se tiver um projeto aberto).
3.  Clique em **Create Virtual Device**.
4.  Escolha um perfil de hardware de telemóvel (p. ex., **Pixel 7**) e clique **Next**.
5.  Selecione uma imagem de sistema para descarregar:
      * Escolha um nível de API recente (p. ex., API 34, Android 14).
      * Clique em **Download** ao lado do nome da imagem e aguarde que termine.
      * Selecione a imagem descarregada e clique **Next**.
6.  Dê um nome ao seu AVD (Android Virtual Device) e clique **Finish**.

#### Passo 3 -- Iniciar e Explorar

1.  No Virtual Device Manager, clique no botão **Play** ao lado do seu dispositivo.
2.  Uma nova janela abrirá mostrando a animação de arranque do Android.
3.  Após arrancar, explore:
      * Abra a aplicação **Settings** e veja as informações do dispositivo.
      * Abra o navegador **Chrome** e visite um website.
      * Abra a aplicação **Files** e explore o sistema de ficheiros virtual.
4.  **Verificar:** O telemóvel emulado deverá comportar-se exatamente como um dispositivo Android real, incluindo entrada tátil (via cliques do rato), rotação e simulação de GPS.

#### Passo 4 -- Reflexão

Responda a estas perguntas nas suas notas de laboratório:

* Que tipo de virtualização usa o emulador Android? É emulação, virtualização completa ou outra coisa?
* Como é que o emulador Android consegue desempenho quase nativo em anfitriões x86?
* Qual é o papel do Android SDK nesta configuração?



### Resumo e Entregáveis

No final deste laboratório, deverá ter:

1.  Uma ferramenta de virtualização funcional (VirtualBox ou QEMU) instalada no seu anfitrião.
2.  Uma VM FreeDOS capaz de executar um jogo clássico de DOS.
3.  Uma VM Alpine Linux com conectividade de rede e um servidor web em funcionamento acessível a partir do anfitrião.
4.  Uma VM Proxmox com uma interface web funcional (e opcionalmente, uma VM aninhada dentro dela).
5.  (Bónus) Um dispositivo virtual Android a funcionar no emulador Android.

**Entregue** as suas notas de laboratório com as respostas a todas as questões de reflexão e capturas de ecrã mostrando:

* A VM FreeDOS a executar o DOOM.
* A página do servidor web Alpine apresentada no navegador do anfitrião.
* O painel de controlo da interface web do Proxmox.