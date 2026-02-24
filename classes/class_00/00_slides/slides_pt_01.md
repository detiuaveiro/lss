---
title: Configuração do Ambiente de Trabalho
---

# Introdução

## Configurar o Seu Ambiente de Trabalho Digital

**Objetivo de hoje:** Garantir que todos têm um ambiente de trabalho consistente e poderoso. Isto ajuda-nos a aprender mais rápido e evita o clássico problema de "mas funciona na minha máquina\!".

Vamos abordar:

- O que é um Sistema Operativo (SO) e como está estruturado.
- Como os sistemas de ficheiros organizam os dados no Windows e no Linux.
- Porquê padronizar o ambiente em Linux nesta unidade curricular.
- Três métodos práticos para configurar um ambiente Linux.

# Sistemas Operativos

## O que é um Sistema Operativo (SO)?

Um SO é a camada de *software* fundamental que gere todos os recursos de *hardware* e fornece serviços aos programas aplicacionais.

As suas responsabilidades principais incluem:

- **Gestão de Processos:** Criar, escalonar e terminar processos (programas em execução).
- **Gestão de Memória:** Alocar e libertar RAM para os processos em execução; implementar memória virtual.
- **Gestão de Armazenamento:** Ler e escrever dados em disco através de controladores de sistema de ficheiros.
- **Gestão de E/S:** Coordenar o acesso a periféricos (teclado, ecrã, placa de rede, dispositivos USB).
- **Segurança e Controlo de Acesso:** Autenticar utilizadores e aplicar permissões de ficheiros.

## Famílias de SO

Vamos focar-nos em duas famílias principais de SO:

- **Windows:** O SO de *desktop* mais comum, utilizado pela maioria dos computadores pessoais em todo o mundo.
- **Linux:** Uma família de SO poderosa e de código aberto (*open-source*), dominante em servidores, computação na nuvem e investigação científica.

## O Computador: Visão Geral do Hardware

Um sistema computacional é construído a partir de três componentes fundamentais que trabalham em conjunto:

<!-- TODO: Adicionar imagem mostrando CPU, RAM e Armazenamento ligados por barramento -->
<!-- Figura sugerida: computer_architecture.png -->

- **Processador (CPU):** A Unidade Central de Processamento executa instruções. Os CPUs modernos têm múltiplos núcleos (*cores*), permitindo a execução paralela de tarefas.
- **Memória (RAM):** A Memória de Acesso Aleatório fornece armazenamento rápido e temporário para dados e instruções que o CPU está a utilizar ativamente. É **volátil** (os dados perdem-se quando a energia é desligada).
- **Armazenamento (Disco/SSD):** Fornece armazenamento persistente e de longo prazo para ficheiros, programas e o próprio SO. É **não volátil**, mas significativamente mais lento que a RAM.

O SO atua como intermediário, decidindo qual processo obtém tempo de CPU, quanta RAM cada processo recebe e como os dados fluem de e para o armazenamento.

## Arquitetura do SO: O Modelo em Camadas

Um SO é organizado em camadas, desde o *hardware* na base até às aplicações do utilizador no topo:

<!-- TODO: Adicionar imagem mostrando diagrama de camadas do SO -->
<!-- Figura sugerida: os_layers.png -->
<!-- Camadas de baixo para cima: -->
<!-- Hardware (CPU, RAM, Disco, Rede) -->
<!-- Kernel (escalonador de processos, gestor de memória, controladores de dispositivos, sistema de ficheiros) -->
<!-- Bibliotecas e Serviços do Sistema (libc, systemd, dbus) -->
<!-- Shell e Utilitários (bash, coreutils, gestor de pacotes) -->
<!-- Aplicações do Utilizador (navegador, editor, os seus programas) -->

- **Hardware:** Os componentes físicos (CPU, RAM, disco, placa de rede).
- **Kernel:** O núcleo do SO. Executa em modo privilegiado e tem acesso direto ao *hardware*. Gere o escalonamento de processos, a alocação de memória, os controladores de dispositivos e as operações do sistema de ficheiros.
- **Bibliotecas e Serviços do Sistema:** Fornecem uma interface padronizada (ex: a biblioteca padrão do C, `libc`) para que as aplicações não precisem de interagir diretamente com o *kernel*.
- **Shell e Utilitários:** A interface de linha de comandos (ex: Bash) e as ferramentas essenciais (`ls`, `cp`, `grep`) que permitem aos utilizadores interagir com o sistema.
- **Aplicações do Utilizador:** Programas como navegadores *web*, editores de texto e o seu próprio código.

# Sistemas de Ficheiros

## O que é um Sistema de Ficheiros? i

Um sistema de ficheiros define como os dados são organizados, armazenados e recuperados num dispositivo de armazenamento. Sem um sistema de ficheiros, os dados num disco seriam um fluxo indiferenciado de *bytes*, sem forma de distinguir onde um ficheiro termina e outro começa.

### Windows: NTFS

O NTFS (*New Technology File System*) é o sistema de ficheiros predefinido nas instalações modernas do Windows.

- Usa **letras de unidade** para identificar volumes (ex: `C:` para a unidade do sistema, `D:` para uma partição secundária).
- O separador de caminho é uma **barra invertida** (`\`).
- Suporta permissões de ficheiros através de **Listas de Controlo de Acesso (ACLs)**.
- Exemplo de caminho: `C:\Users\OSeuNome\Documents\relatorio.txt`

### Linux: ext4

O ext4 (*Fourth Extended Filesystem*) é o sistema de ficheiros Linux mais comum (outros incluem Btrfs e XFS).

- Tem um **diretório raiz** (`/`) único e unificado. Não existem letras de unidade.
- Tudo é representado como um ficheiro, incluindo dispositivos de *hardware* (ex: `/dev/sda1`).
- O separador de caminho é uma **barra** (`/`).
- Utiliza um **modelo de permissões** baseado em dono, grupo e outros (leitura, escrita, execução).
- Exemplo de caminho: `/home/oseunome/documents/relatorio.txt`

## O que é um Sistema de Ficheiros? ii

### O Padrão de Hierarquia do Sistema de Ficheiros Linux (FHS)

O Linux organiza os seus diretórios seguindo um padrão bem definido. Os diretórios principais incluem:

![Padrão de Hierarquia do Sistema de Ficheiros Linux](FHS.png){width=90%}

## O que é um Sistema de Ficheiros? iii

### Diretórios Principais do Linux

| Diretório | Finalidade |
| :--- | :--- |
| `/` | Raiz de toda a hierarquia do sistema de ficheiros |
| `/home` | Diretórios pessoais dos utilizadores regulares |
| `/etc` | Ficheiros de configuração do sistema |
| `/var` | Dados variáveis: *logs*, *caches*, ficheiros de *spool* |
| `/usr` | Programas, bibliotecas e documentação do utilizador |
| `/tmp` | Ficheiros temporários (limpos no reinício) |
| `/dev` | Ficheiros de dispositivos que representam *hardware* |
| `/proc` | Sistema de ficheiros virtual que expõe informação do *kernel* e dos processos |

**Conclusão importante:** Compreender a estrutura de caminhos é essencial para navegar no sistema, escrever *scripts* e executar programas a partir da linha de comandos.

# Porquê Linux?

## Porquê um Ambiente Padronizado? i

Estamos a padronizar um **ambiente de linha de comandos baseado em Linux** por várias razões importantes:

**Domínio na Indústria:**

- Mais de **96%** dos 1 milhão de servidores *web* mais utilizados no mundo executam Linux.
- Todas as principais plataformas *cloud* (AWS, Google Cloud, Azure) utilizam Linux como SO principal.
- O Android, o SO móvel mais popular do mundo, é construído sobre o *kernel* Linux.

**Ferramentas Poderosas:**

- Oferece um rico ecossistema de ferramentas de linha de comandos para processamento de texto (`grep`, `sed`, `awk`), automação (`bash`, `cron`) e desenvolvimento (`gcc`, `make`, `git`).
- Os gestores de pacotes (`apt`, `dnf`) tornam a instalação de *software* simples e reprodutível.

## Porquê um Ambiente Padronizado? ii

**Transparência e Controlo:**

- Código aberto: pode inspecionar, modificar e aprender a partir do código-fonte.
- Encoraja a compreensão de como os sistemas realmente funcionam, em vez de depender de abstrações gráficas.

**Reprodutibilidade:**

- Um ambiente Linux partilhado significa que todos na unidade curricular trabalham com as mesmas ferramentas, os mesmos caminhos e o mesmo comportamento. Isto elimina erros relacionados com a configuração e facilita a entreajuda.

Agora, vamos explorar as opções para configurar este ambiente.

# Configurar o Linux

## Os Três Caminhos para o Linux

1. **Instalação Nativa de Linux:**
     - Instalar Linux diretamente no *hardware* como SO principal (ou secundário).
     - **Ideal para:** Desempenho máximo e imersão total.

2. **Máquina Virtual (VM):**
     - Executar um sistema Linux completo dentro de uma janela no SO atual, usando *software* de virtualização.
     - **Ideal para:** Experimentação segura com isolamento total do sistema anfitrião.

3. **Subsistema Windows para Linux (WSL):**
     - Executar um *kernel* e ambiente Linux reais diretamente no Windows, com integração profunda entre os dois sistemas.
     - **Ideal para:** Utilizadores de Windows que querem desempenho Linux quase nativo sem reiniciar ou executar uma VM completa.

Cada opção tem compromissos. Vamos examiná-las em detalhe.

# Instalação Nativa de Linux

## Instalação Nativa de Linux i

Isto significa instalar uma distribuição Linux (como Ubuntu ou Fedora) diretamente no *hardware* do computador, substituindo o SO atual ou instalando-o ao lado numa configuração de **arranque duplo** (*dual-boot*).

### Como Funciona o Arranque Duplo

- O gestor de arranque (tipicamente o GRUB) apresenta um menu no início, permitindo escolher entre Windows e Linux.
- Cada SO ocupa a sua própria partição de disco e opera de forma independente.
- Apenas um SO é executado de cada vez, pelo que o SO ativo tem acesso total a todos os recursos de *hardware*.

### Prós

- **Melhor Desempenho:** Sem sobrecarga de virtualização; o Linux tem acesso direto ao CPU, GPU, RAM e todos os periféricos.
- **Imersão Total:** Obriga a aprender o ambiente Linux em profundidade.
- **Acesso Total ao Hardware:** Acesso direto à aceleração GPU, dispositivos USB e *hardware* de rede.

## Instalação Nativa de Linux ii

### Contras

- **Configuração Complexa:** O particionamento de disco acarreta um risco real de perda de dados se feito incorretamente. ***Backups* são essenciais.**
- **Compatibilidade de Hardware:** Algum *hardware* (chipsets Wi-Fi específicos, leitores de impressão digital, certas GPUs) pode requerer instalação manual de controladores ou configuração do *kernel*.
- **Mudança Inconveniente:** Alternar entre Windows e Linux requer um reinício completo.

### Para quem é esta opção?

Estudantes que estão à vontade com *hardware* de computador, que gostam de aprender fazendo, ou que têm uma máquina extra para dedicar ao Linux.

### Passos de Configuração

1. **Escolha uma distribuição:** Recomendamos o **Ubuntu 24.04 LTS** ou o **Debian 12** pela sua estabilidade e extenso suporte da comunidade.
2. **Crie uma pen USB de arranque:** Use o [Rufus](https://rufus.ie/) (Windows) ou o [BalenaEtcher](https://www.balena.io/etcher/) (multiplataforma).
3. **Faça *backup* dos seus dados.** Este passo é inegociável.
4. **Particione o disco rígido** durante a instalação. Reserve pelo menos 40 GB para a partição Linux.
5. **Arranque a partir da pen USB** e siga as instruções do instalador.

# Máquina Virtual

## Máquina Virtual (VM) i

Uma Máquina Virtual usa um ***hypervisor*** para emular um sistema computacional completo dentro do SO existente. O *hypervisor* cria uma camada de abstração que apresenta *hardware* virtual (CPU, RAM, disco, rede) ao SO convidado.

<!-- TODO: Adicionar imagem mostrando arquitetura de Hypervisor Tipo 1 vs Tipo 2 -->
<!-- Figura sugerida: vm_architecture.png -->

### Tipos de Hypervisors

- **Tipo 1 (Bare-metal):** Executa diretamente sobre o *hardware*, sem SO anfitrião. Exemplos: VMware ESXi, Microsoft Hyper-V, Xen. Usado em centros de dados e ambientes empresariais.
- **Tipo 2 (Hosted):** Executa como uma aplicação sobre o SO anfitrião. Exemplos: VirtualBox, VMware Workstation, UTM. É o que utilizamos nesta unidade curricular.

### Alocação de Recursos

Ao criar uma VM, atribui-lhe uma parte fixa dos recursos do seu sistema:

- **Núcleos de CPU:** Tipicamente 2 ou mais núcleos virtuais.
- **RAM:** Pelo menos 2 GB para a VM (o sistema anfitrião deve ter 8 GB+ no total).
- **Disco:** Um ficheiro de disco virtual (tipicamente 20--40 GB) armazenado no sistema de ficheiros do anfitrião.

## Máquina Virtual (VM) ii

### Modos de Rede

A VM precisa de acesso à rede para descarregar *software* (`apt install`), usar o `git` e aceder à *web*. O *hypervisor* oferece vários modos de rede:

- **NAT (Network Address Translation):** O modo predefinido. A VM partilha o endereço IP do anfitrião. As ligações de saída funcionam de forma transparente; as ligações de entrada requerem reencaminhamento de portas. É a opção mais simples e mais comum.
- **Adaptador em Ponte (*Bridged*):** A VM obtém o seu próprio endereço IP na rede física, como se fosse uma máquina física separada. Útil quando a VM precisa de ser acessível a partir de outros dispositivos na rede.
- **Apenas Anfitrião (*Host-Only*):** Cria uma rede privada apenas entre o anfitrião e a VM. Sem acesso à internet, mas útil para testes isolados.

### Prós

- **Segura e Isolada:** A VM é uma *sandbox*. Se danificar o SO convidado, o anfitrião não é afetado. Pode tirar ***snapshots*** para guardar o estado da VM e reverter a qualquer momento.
- **Configuração Fácil:** Instale o VirtualBox, importe a imagem da unidade curricular e comece a trabalhar.
- **Portátil:** A imagem da VM (ficheiro `.ova`) pode ser copiada para outra máquina.

## Máquina Virtual (VM) iii

### Contras

- **Exigente em Recursos:** Executar dois sistemas operativos completos em simultâneo exige RAM e CPU significativos. Sistemas com menos de 8 GB de RAM terão dificuldades.
- **Desempenho Mais Lento:** A camada de virtualização introduz sobrecarga, especialmente para E/S de disco e gráficos.
- **Acesso Limitado à GPU:** A aceleração 3D e o *passthrough* de GPU são limitados em *hypervisors* de Tipo 2.

### Nota para Utilizadores Mac (Apple Silicon: M1/M2/M3/M4)

O VirtualBox tem suporte limitado para os chips ARM do Apple Silicon. Se utilizar um Mac com Apple Silicon, recomendamos o **UTM** (gratuito, código aberto) ou o **VMware Fusion** (gratuito para uso pessoal).

### Para quem é esta opção?

Esta é a **opção recomendada por defeito** para a unidade curricular. É a mais segura, a mais consistente e não requer alterações ao SO existente.

## Máquina Virtual (VM) iv

### Passos de Configuração

1. **Instale o Hypervisor:**
     - Windows / Intel Mac: Descarregue e instale o [VirtualBox](https://www.virtualbox.org/).
     - Apple Silicon Mac: Descarregue e instale o [UTM](https://mac.getutm.app/).
2. **Descarregue a Imagem da VM:** Obtenha o ficheiro `.ova` no *site* da unidade curricular.
3. **Importe a *Appliance*:** No VirtualBox, vá a `Ficheiro > Importar Appliance`, selecione o ficheiro `.ova` e siga as instruções. Ajuste a alocação de RAM e CPU se necessário.
4. **Inicie a VM:** Selecione a máquina importada e clique em **Iniciar**.
5. **Verifique:** Abra um terminal dentro da VM e execute `uname -a` para confirmar que está a executar Linux.

# Subsistema Windows para Linux

## Subsistema Windows para Linux (WSL) i

O WSL permite executar um *kernel* e espaço de utilizador Linux genuínos diretamente no Windows, sem a sobrecarga de uma máquina virtual completa. A Microsoft desenvolveu o WSL para trazer compatibilidade nativa com Linux ao Windows.

### WSL 1 vs. WSL 2

| Característica | WSL 1 | WSL 2 |
| :--- | :--- | :--- |
| **Arquitetura** | Camada de tradução (mapeamento de *syscalls*) | VM ligeira com *kernel* Linux real |
| **Desempenho do Sist. Ficheiros** | Mais lento em ficheiros Linux | Rápido em ficheiros Linux (`/home`) |
| **Compatibilidade de *Syscalls*** | Parcial | Total |
| **Rede** | Partilha a *stack* de rede do anfitrião | Adaptador de rede virtual |
| **Uso de Memória** | Menor | Dinâmico (cresce/diminui conforme necessário) |

**Utilizamos o WSL 2**, que inclui um *kernel* Linux real numa máquina virtual ligeira e gerida. Oferece compatibilidade total de chamadas de sistema e excelente desempenho.

## Subsistema Windows para Linux (WSL) ii

### Como Funciona: Integração do Sistema de Ficheiros

- As unidades do Windows são automaticamente montadas dentro do Linux em `/mnt/`. Por exemplo, `C:\Users\OSeuNome` é acessível em `/mnt/c/Users/OSeuNome`.
- O sistema de ficheiros do Linux reside num disco virtual separado, acessível a partir do Explorador de Ficheiros do Windows navegando para `\\wsl$\Ubuntu\home\oseunome`.

**Importante:** Para o melhor desempenho, armazene sempre os ficheiros dos seus projetos dentro do sistema de ficheiros do Linux (`/home/oseunome/`), e não nas unidades montadas do Windows (`/mnt/c/`). O acesso entre sistemas de ficheiros é significativamente mais lento.

### Como Funciona: Rede

- O WSL 2 utiliza um adaptador de rede virtual com o seu próprio endereço IP.
- O acesso à internet funciona de forma transparente através do anfitrião.
- Para aceder a um servidor a correr dentro do WSL a partir do Windows, use `localhost` (as versões recentes do Windows suportam isto automaticamente).

## Subsistema Windows para Linux (WSL) iii

### Prós

- **Excelente Desempenho:** Velocidade quase nativa para ferramentas de linha de comandos, compiladores e *scripting*.
- **Suporte para Aplicações Gráficas (GUI):** O WSL 2 suporta a execução de aplicações gráficas Linux (via WSLg) ao lado das aplicações Windows.
- **Integração Transparente:** Execute comandos Linux a partir do PowerShell (`wsl ls -la`) e executáveis Windows a partir do Linux (`explorer.exe .`). Partilhe variáveis de ambiente e a área de transferência.
- **Baixo Consumo de Recursos:** A VM ligeira inicia em segundos e usa memória de forma dinâmica.

### Contras

- **Apenas Windows:** Não disponível em macOS ou Linux nativo (obviamente).
- **Complexidade de Rede Avançada:** Reencaminhamento de portas, regras de *firewall* e acesso a dispositivos USB requerem configuração adicional comparativamente a uma VM completa.
- **Diferenças Subtis:** Fins de linha (`\r\n` vs `\n`), permissões de ficheiros e formatos de caminhos podem causar problemas se misturar os sistemas de ficheiros do Windows e do Linux descuidadamente.

### Para quem é esta opção?

Utilizadores de Windows que querem um ambiente Linux rápido e profundamente integrado, sem a sobrecarga de uma VM completa ou o compromisso de uma instalação nativa.

## Subsistema Windows para Linux (WSL) iv

### Passos de Configuração

1. **Ative o WSL:** Abra o **PowerShell como Administrador** e execute:

   ```
   wsl --install
   ```

   Este comando ativa as funcionalidades necessárias do Windows, descarrega o *kernel* Linux e instala o **Ubuntu** por defeito. Para instalar uma distribuição diferente:

   ```
   wsl --install -d Debian
   ```

2. **Reinicie** o seu computador quando solicitado.
3. **Crie uma Conta de Utilizador:** Após o reinício, uma janela de terminal abre-se automaticamente. Crie o seu nome de utilizador e *password* Linux.
4. **Verifique a instalação:** Execute os seguintes comandos:

   ```
   cat /etc/os-release
   uname -r
   ```

5. **Inicie a qualquer momento:** Abra "Ubuntu" (ou "Debian") a partir do Menu Iniciar, ou escreva `wsl` no PowerShell.

# Conclusão

## Resumo: Escolher o Seu Ambiente

A sua escolha depende do seu nível de conforto, *hardware* e preferências.

\begin{table}
\centering
\begin{tabular}{lccc}
\toprule
Característica & Instalação Nativa & VM & WSL \\
\midrule
Desempenho & Excelente & Moderado & Excelente \\
Segurança/Isolamento & Baixo & Alto & Moderado \\
Facilidade de Config. & Baixa & Alta & Moderada \\
Acesso ao Hardware & Total & Limitado & Limitado \\
Impacto no SO Anfitrião & Alto & Nenhum & Nenhum \\
Recomendado Para & Entusiastas & \textbf{Todos} & Utilizadores Windows \\
\bottomrule
\end{tabular}
\end{table}

A **Máquina Virtual** é a recomendação por defeito para esta unidade curricular, pela sua segurança, consistência e facilidade de configuração.

## Próximos Passos

### A Sua Tarefa Agora:

1. **Escolha um** dos três métodos (VM é recomendada se estiver indeciso).
2. Siga as instruções de configuração para pôr o seu ambiente Linux a funcionar.
3. Abra um terminal e confirme que funciona executando:

   ```
   echo "Olá a partir do Linux!"
   uname -a
   ```

4. Esteja pronto para a próxima sessão com um ambiente funcional.

### Precisa de Ajuda?

- Consulte o *site* da unidade curricular para guias de configuração detalhados e o *download* da imagem da VM.
- Fale com os seus professores ou assistentes durante o horário de atendimento.
- Colabore com colegas; muitos problemas de configuração são comuns e estão bem documentados.

Configurar o seu ambiente é o primeiro passo importante. Boa sorte!