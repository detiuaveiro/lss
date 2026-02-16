---
title: Configuração do Ambiente de Trabalho
Subtitle: Laboratórios de Sistemas e Serviços
author: Mário Antunes
institute: Universidade de Aveiro
date: 09 de Fevereiro de 2026
colorlinks: true
highlight-style: tango
mainfont: NotoSans
mainfontfallback:
  - "NotoColorEmoji:mode=harf"
theme: metropolis
themeoptions:
  - sectionpage=progressbar
  - numbering=fraction
  - progressbar=frametitle
header-includes:
 - \usepackage{longtable,booktabs}
 - \usepackage{etoolbox}
 - \AtBeginEnvironment{longtable}{\tiny}
 - \AtBeginEnvironment{cslreferences}{\tiny}
 - \AtBeginEnvironment{Shaded}{\tiny}
 - \AtBeginEnvironment{verbatim}{\tiny}
 - \setmonofont[Contextuals={Alternate}]{FiraCodeNerdFontMono-Retina}
---

# Configurar o Seu Ambiente de Trabalho Digital

**Objetivo de hoje:** Garantir que todos têm um ambiente de trabalho consistente e poderoso. Isto ajuda-nos a aprender mais rápido e evita o clássico problema de "mas funciona na minha máquina\!".

# O que é um Sistema Operativo (SO)?

Pense num SO como o **gestor** dos recursos do seu computador. 🧑‍💼

  * É o *software* que executa tudo o resto.
  * Gere o **CPU** (o cérebro), a **memória** (o espaço de trabalho) e o **armazenamento** (o arquivo).
  * Fornece uma **interface de utilizador** (UI) para que possa interagir com a máquina.

Vamos focar-nos em duas famílias principais:

  * **🪟 Windows:** O SO de *desktop* mais comum.
  * **🐧 Linux:** Uma família de SO poderosa e de código aberto (*open-source*), dominante em servidores, computação na nuvem e investigação científica.

# O que é um Sistema de Ficheiros (*Filesystem*)?

Um sistema de ficheiros é o **catálogo da biblioteca** do seu computador. É a forma como o SO organiza, armazena e encontra os seus ficheiros. 🗂️

## **Windows (NTFS)**

  * Usa **letras de unidade** (ex: `C:`, `D:`).
  * O separador de caminho é uma **barra invertida (`\`)**.
  * Exemplo: `C:\Users\OSeuNome\Documents\OmeuFicheiro.txt`

## **Linux (ext4, Btrfs, etc.)**

  * Tem um **diretório raiz (`/`)** único e unificado.
  * Tudo, incluindo dispositivos, é tratado como um ficheiro.
  * O separador de caminho é uma **barra (`/`)**.
  * Exemplo: `/home/oseunome/documents/omeuficheiro.txt`

> **Conclusão importante:** Compreender a estrutura de caminhos é crucial para encontrar os seus ficheiros e executar programas a partir da linha de comandos\!

# Porquê um Ambiente Padronizado? (A Escolha "Linux")

Estamos a padronizar um **ambiente de linha de comandos baseado em Linux** porque:

  * **É o Padrão da Indústria:** É a espinha dorsal da *web*, da computação na nuvem (*cloud*, AWS, Google Cloud) e da computação científica.
  * **Oferece Ferramentas Poderosas:** Disponibiliza ferramentas inigualáveis para programação, automação e manipulação de dados.
  * **É Transparente:** Ajuda a compreender o que o computador está *realmente* a fazer.

Agora, vamos explorar as suas opções para configurar este ambiente\!

# Os Seus Três Caminhos para o Linux 🗺️

1.  **Instalação Nativa de Linux:**

      * **O quê:** O Linux é o SO principal no seu computador.
      * **Ideal para:** Desempenho máximo e imersão total.

2.  **Máquina Virtual (VM):**

      * **O quê:** Um computador Linux completo a correr dentro de uma janela no seu SO atual.
      * **Ideal para:** Ser seguro, isolado e fácil de restaurar.

3.  **Subsistema Windows para Linux (WSL):**

      * **O quê:** Uma camada de compatibilidade para executar um ambiente Linux real diretamente no Windows.
      * **Ideal para:** Integração forte entre as ferramentas Windows e Linux.

# Opção 1: Instalação Nativa de Linux 🐧

Isto significa que instala uma distribuição Linux (como Ubuntu ou Fedora) diretamente no *hardware* do seu computador, substituindo o Windows ou instalando-o ao lado ("arranque duplo" ou *dual-booting*).

## **Prós & Contras**

  * **✅ Pró:** **Melhor Desempenho.** Sem sobrecarga; o Linux tem acesso direto a todo o *hardware* (CPU, GPU).
  * **✅ Pró:** **Imersão Total.** Força-o a aprender e a adaptar-se ao ambiente Linux.
  * **❌ Contra:** **Configuração Complexa.** Pode ser complicado, com riscos de perda de dados se não for feito com cuidado (o *backup* é essencial\!).
  * **❌ Contra:** **Compatibilidade de Hardware.** Algum *hardware* específico (placas Wi-Fi, *webcams*) pode exigir configuração extra.

## **Para quem é esta opção?**

Estudantes que são aventureiros, à vontade com *hardware* de computador, ou que têm uma máquina extra para experimentar.

## **Passos de Configuração**

1.  **Escolha uma distribuição:** Recomendamos o **Ubuntu 24.04 LTS** ou **Debian 13.3** pelo seu excelente suporte.
2.  **Crie uma pen USB de arranque:** Use ferramentas como [Rufus](https://rufus.ie/) ou [BalenaEtcher](https://www.balena.io/etcher/).
3.  **Particione o seu disco rígido:** Este é o passo mais crítico se planeia fazer *dual-boot*. **FAÇA BACKUP DOS SEUS DADOS PRIMEIRO\!**
4.  **Arranque a partir da pen USB** e siga as instruções do instalador.

# Opção 2: Máquina Virtual (VM) 🖥️

Uma VM usa um ***hypervisor*** (como o VirtualBox ou VMWare) para emular um sistema de computador completo dentro do seu SO existente. Nós fornecemos uma imagem pré-configurada para facilitar o processo\!

## **Como Funciona: Rede (*Networking*)**

A sua VM precisa de acesso à rede para descarregar *software* (`apt install`) ou usar o `git`.

  * O *hypervisor* cria um adaptador de rede virtual para a sua VM.
  * Geralmente usa **NAT (Network Address Translation)**, que funciona como um *router*, permitindo que a VM partilhe a ligação à internet do seu computador anfitrião de forma segura.

## **Prós & Contras**

  * **✅ Pró:** **Segura & Isolada.** A VM é uma *sandbox*. Se a danificar, não afeta o seu SO principal. Pode facilmente apagá-la ou restaurá-la a partir de um *snapshot*.
  * **✅ Pró:** **Configuração Fácil.** Basta instalar o VirtualBox e importar a imagem da unidade curricular.
  * **❌ Contra:** **Exigente em Recursos.** Requer uma quantidade significativa de RAM (8GB+ recomendado para todo o sistema) e poder de CPU, pois está a executar dois sistemas operativos ao mesmo tempo.
  * **❌ Contra:** **Desempenho Mais Lento.** Mais lento do que uma instalação nativa devido à sobrecarga da virtualização.

  > **⚠️ Utilizadores Mac (M1/M2/M3):** O VirtualBox tem fraco desempenho em Apple Silicon. Recomendamos o uso de **UTM** ou **VMware Fusion**.

## **Passos de Configuração**

  1.  **Instale o Hypervisor:** Descarregue o [VirtualBox](https://www.virtualbox.org/) (Windows/Intel Mac) ou **UTM** (Apple Silicon Mac).
  2.  **Descarregue a Imagem da VM:** Obtenha o ficheiro no site da unidade curricular.
  3.  **Importe a *Appliance*:** Selecione "Importar" no seu software e escolha o ficheiro descarregado.
  4.  **Inicie a sua VM:** Selecione a máquina e clique em "Iniciar". É tudo!

# Opção 3: Subsistema Windows para Linux (WSL) 🪟+🐧

O WSL permite-lhe executar um *kernel* e ambiente Linux genuínos diretamente no Windows, sem a sobrecarga de uma VM completa.

## **Como Funciona: Sistema de Ficheiros & Rede**

* **Rede:** O WSL partilha automaticamente a ligação de rede do seu anfitrião Windows.
* **Integração de Sistema de Ficheiros:** As suas unidades do Windows (como `C:`) são montadas dentro do Linux em `/mnt/`.

> **⚠️ Importante:** Para o melhor desempenho, trabalhe sempre com os seus ficheiros dentro do sistema de ficheiros do Linux (`/home/oseunome/`), e não nas unidades do Windows (`/mnt/c/`).

## **Prós & Contras**

* **✅ Pró:** **Excelente Desempenho.** Velocidade quase nativa para ferramentas de linha de comandos.
* **✅ Pró:** **Suporte Gráfico (GUI).** Execute aplicações gráficas (como gedit ou nautilus) diretamente ao lado das apps Windows.
* **✅ Pró:** **Ótima Integração.** Chame facilmente ferramentas Linux a partir do Windows e vice-versa.
* **❌ Contra:** **Complexidade.** Acesso avançado a redes ou hardware (como USB) pode ser mais complexo do que numa VM.

## **Para quem é esta opção?**

Utilizadores de Windows que querem um ambiente rápido e integrado e que desejam usar ferramentas Linux em conjunto com o Windows.

## **Passos de Configuração**

1.  **Ative o WSL:** Abra o PowerShell **como Administrador** e execute:
    ```powershell
    wsl --install
    ```
    Isto instala as funcionalidades necessárias e o **Ubuntu 24.04 LTS** (pode optar por **Debian 13.3**) por defeito.
2.  **Reinicie** o seu computador quando solicitado.
3.  **Crie uma Conta de Utilizador:** Uma janela de terminal abrir-se-á para completar a instalação. Crie o seu nome de utilizador e *password*.
4.  **Está Pronto!** Inicie o "Ubuntu" a partir do Menu Iniciar.

# Resumo & Próximos Passos ✅

Tem três ótimas opções. A sua escolha depende do seu nível de conforto e do seu computador.

| Característica | Instalação Nativa | Máquina Virtual (VM) | WSL |
| :--- | :---: | :---: | :---: |
| **Desempenho** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| **Segurança/Isolamento**| ⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Facilidade de Config.**| ⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Recomendado Para**| Especialistas/Entusiastas | **Todos (Padrão)** | Utilizadores de Windows |

## **A Sua Tarefa Agora:**

1.  **Escolha um** dos três métodos.
2.  Siga as instruções de configuração para o pôr a funcionar.
3.  Abra um terminal e esteja pronto para a nossa próxima sessão\!

**Está com dificuldades? Não se preocupe\!** Peça ajuda aos seus professores, monitores ou colegas. Configurar o seu ambiente é o primeiro passo importante. Boa sorte\! 🎉
