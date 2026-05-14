# Virtualização de Sistemas

## Introdução

A **Virtualização** é uma tecnologia fundamental que permite a criação de uma versão baseada em *software* de um computador físico, com recursos de CPU, memória e armazenamento abstraídos do hardware real. Esta "máquina dentro de uma máquina", conhecida como Máquina Virtual (VM), funciona como uma aplicação no computador anfitrião, mas comporta-se, para todos os efeitos, como um computador independente com o seu próprio sistema operativo e aplicações.

Para compreender o funcionamento desta tecnologia, é essencial definir três conceitos base:
- **Anfitrião (*Host*):** Refere-se à máquina física real e ao sistema operativo que nela reside.
- **Convidado (*Guest*):** Refere-se à máquina virtual e ao sistema operativo que nela é executado.
- **Hipervisor:** É a camada de *software* (ou *firmware*) responsável por criar, gerir e isolar as máquinas virtuais, distribuindo os recursos do anfitrião de forma segura.

### O Desafio das Instruções Privilegiadas e Anéis de Proteção

O maior desafio técnico da virtualização reside na gestão das instruções de CPU. A arquitetura x86 utiliza **Anéis de Proteção** (*Protection Rings*) para isolar o sistema operativo das aplicações.

- **Anel 0 (*Ring 0*):** Reservado para o *kernel* do sistema operativo. Tem acesso total ao hardware e pode executar "instruções privilegiadas".
- **Anéis 1 e 2:** Raramente utilizados em sistemas modernos.
- **Anel 3 (*Ring 3*):** Onde correm as aplicações do utilizador. O acesso ao hardware é restrito e deve ser solicitado ao *kernel* através de chamadas de sistema (*system calls*).

Num ambiente virtualizado, o SO convidado acredita que está no Anel 0. No entanto, o hipervisor real já ocupa o Anel 0 do hardware. O papel do hipervisor é intercetar as tentativas do SO convidado de executar instruções privilegiadas e geri-las sem comprometer a estabilidade do anfitrião.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    ring/.style={draw, circle, line width=1pt},
    label/.style={font=\sffamily\scriptsize, align=center}
]
    \node (r0) [ring, minimum size=1.5cm, fill=red!20] {};
    \node (r1) [ring, minimum size=3cm] {};
    \node (r2) [ring, minimum size=4.5cm] {};
    \node (r3) [ring, minimum size=6cm] {};

    \node at (0, 0.45) [label] {Anel 0};
    \node at (0, 1.2) [label] {Anel 1};
    \node at (0, 2.0) [label] {Anel 2};
    \node at (0, 2.7) [label] {Anel 3\\(Aplicações)};
    
    \node at (0, -0.1) [label, font=\sffamily\tiny\bfseries] {Kernel /\\Hipervisor};

    \draw[<->, thick] (0.8, 0) -- (2.8, 0) node[midway, above, font=\tiny] {System Calls};
\end{tikzpicture}
\end{center}
```

## Tipos de Hipervisores

Existem duas categorias principais de hipervisores:

1.  **Tipo 1 (Nativo ou *Bare-metal*):** O hipervisor corre diretamente no hardware. É o sistema operativo. Oferece o melhor desempenho pois não existe uma camada de SO intermédia. É a escolha para centros de dados (ex: VMware ESXi, Xen, KVM).
2.  **Tipo 2 (Hospedado):** O hipervisor corre como uma aplicação num SO anfitrião. É mais fácil de instalar e utilizar em computadores de secretária, mas introduz mais sobrecarga (ex: VirtualBox, VMware Workstation).

## Estratégias de Virtualização e Assistência de Hardware

### Virtualização por Software (Binária)
Utilizada antes da assistência de hardware existir. O hipervisor analisava o código do convidado em tempo real e substituía instruções privilegiadas por chamadas seguras. Extremamente complexo e lento.

### Virtualização Assistida por Hardware
As CPUs modernas incluem extensões (**Intel VT-x** e **AMD-V**) que criam um novo modo de execução abaixo do Anel 0 (chamado *Root Mode* ou Anel -1). Isto permite que o SO convidado corra realmente no Anel 0 real, e o hardware interceta automaticamente as instruções críticas (**"Trap"**) e as entrega ao hipervisor.

### Paravirtualização e VirtIO
Em vez de simular hardware real (que é lento), a paravirtualização utiliza dispositivos "falsos" altamente otimizados. O **VirtIO** é a norma para isto. O convidado utiliza *drivers* específicos que sabem como comunicar com o hipervisor através de filas de memória partilhada (*virtqueues*), evitando o custo de emular registos de hardware reais.

## Armazenamento Virtual: Formatos de Disco

Os discos das VMs são ficheiros no anfitrião. Os formatos mais comuns são:

- **RAW:** Uma imagem bit-a-bit do disco. Desempenho máximo, mas ocupa o espaço total imediatamente e não suporta funcionalidades avançadas.
- **QCOW2 (QEMU Copy-On-Write):** O formato padrão do QEMU/KVM.
    - **Alocação Dinâmica:** O ficheiro só cresce à medida que os dados são escritos.
    - **Snapshots:** Permite guardar o estado do disco.
    - **Backing Files:** Permite criar uma VM "filha" que lê de uma imagem base e apenas escreve as alterações num novo ficheiro.

## Exemplos Práticos: Linha de Comandos

### VBoxManage (VirtualBox)
Para automatizar tarefas no VirtualBox sem usar a interface gráfica:

```bash
# Criar uma nova VM
VBoxManage createvm --name "ServidorWeb" --ostype "Debian_64" --register

# Configurar memória e CPUs
VBoxManage modifyvm "ServidorWeb" --memory 2048 --cpus 2 --vram 128

# Adicionar uma controladora de disco e anexar um ficheiro VDI
VBoxManage storagectl "ServidorWeb" --name "SATA" --add sata --controller IntelAhci
VBoxManage storageattach "ServidorWeb" --storagectl "SATA" --port 0 --device 0 \
  --type hdd --medium ./meu_disco.vdi

# Configurar Port Forwarding para SSH
VBoxManage modifyvm "ServidorWeb" --natpf1 "ssh,tcp,,2222,,22"

# Iniciar em modo 'headless' (sem janela)
VBoxManage startvm "ServidorWeb" --type headless
```

### QEMU / KVM
O QEMU oferece um controlo granular sobre o hardware emulado:

```bash
# Criar um disco QCOW2 de 20GB
qemu-img create -f qcow2 disco.qcow2 20G

# Lançar VM com aceleração KVM e interface de rede VirtIO
qemu-system-x86_64 -enable-kvm \
  -m 2G -smp 2 \
  -hda disco.qcow2 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=net0 \
  -display none -vga none -daemonize
```

## Recursos Adicionais

- **[Intel VT-x Specification](https://www.intel.com/content/www/us/en/virtualization/virtualization-technology/intel-virtualization-technology.html):** Detalhes técnicos sobre a assistência de hardware.
- **[VirtIO Specification](https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.html):** A norma para I/O paravirtualizado.
- **[QEMU Documentation](https://www.qemu.org/docs/master/):** Manual completo do utilizador e sistema.
