# A Linha de Comandos Linux

## Introdução

A **Linha de Comandos** (CLI - *Command Line Interface*) é frequentemente vista como uma barreira de entrada para novos utilizadores, mas é, na verdade, uma das ferramentas mais poderosas e eficientes à disposição de um profissional de informática. Ao contrário da Interface Gráfica (GUI), que limita o utilizador às opções pré-definidas em menus e botões, a linha de comandos permite uma interação direta e sem filtros com o sistema operativo.

Esta interface baseada em texto oferece várias vantagens fundamentais. Em primeiro lugar, o **poder e a velocidade**: tarefas que exigiriam dezenas de cliques podem ser executadas com um único comando. Em segundo lugar, a **automação**: através de *scripts*, é possível automatizar tarefas repetitivas e complexas. Além disso, a CLI é extremamente **eficiente** em termos de recursos, não exigindo o processamento gráfico de uma GUI, o que a torna ideal para a gestão de servidores remotos. Por fim, é um **padrão da indústria**; quer esteja a configurar um servidor na nuvem, a gerir um sistema embebido ou a programar, o domínio da linha de comandos é uma competência indispensável.

### A Shell e o Bash

É importante distinguir entre o **terminal** e a **shell**. O terminal é a janela ou aplicação que permite a entrada e saída de texto. A *shell*, por outro lado, é o programa que interpreta os comandos introduzidos e os envia ao sistema operativo para execução. Pode pensar-se no terminal como a "cara" e na *shell* como o "cérebro" da operação.

Existem diversas *shells* disponíveis no ecossistema Linux:
- **sh (Bourne Shell):** A *shell* original do sistema Unix, simples e clássica.
- **bash (Bourne Again SHell):** Uma evolução da *sh*, é a *shell* padrão na maioria das distribuições Linux e o foco principal deste curso.
- **zsh e fish:** *Shells* modernas que oferecem funcionalidades avançadas de personalização, auto-completar e sugestões inteligentes.

## O Sistema de Ficheiros Linux

Ao contrário do Windows, que utiliza letras de unidade (como `C:` ou `D:`) para identificar diferentes dispositivos de armazenamento, o Linux utiliza uma **árvore única e unificada**. Tudo no sistema, desde ficheiros de texto a discos rígidos e impressoras, está organizado sob um único diretório raiz, representado por uma barra diagonal: `/`.

### A Hierarquia Padrão (FHS)

O Linux segue o *Filesystem Hierarchy Standard* (FHS), que define a finalidade de cada diretório principal:

- **`/` (Raiz):** O ponto de partida de todo o sistema.
- **`/home`:** Onde se localizam os diretórios pessoais dos utilizadores (ex: `/home/aluno`). É o único local onde um utilizador comum tem permissão total para criar e modificar ficheiros.
- **`/bin` e `/usr/bin`:** Contêm os programas (binários) essenciais do sistema e do utilizador, como `ls`, `cp` e `bash`.
- **`/etc`:** Centraliza os ficheiros de configuração de todo o sistema. Quase tudo o que configura o comportamento do SO está aqui.
- **`/var`:** Armazena dados que mudam frequentemente, como registos de eventos do sistema (*logs*) e bases de dados.
- **`/tmp`:** Destinado a ficheiros temporários. Em muitos sistemas, o conteúdo deste diretório é apagado automaticamente ao reiniciar.
- **`/root`:** O diretório pessoal do superutilizador (administrador). Note que este é diferente da raiz `/`.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1cm and 0.5cm,
    folder/.style={draw, fill=blue!10, minimum width=1.6cm, minimum height=0.6cm, rounded corners=1pt, font=\sffamily\tiny, align=center},
    root/.style={draw, fill=blue!30, minimum width=1.2cm, minimum height=0.7cm, rounded corners=2pt, font=\sffamily\bfseries\small}
]
    \node (root) [root] {/};
    \node (home)  [folder, below=of root] {/home};
    \node (bin)   [folder, left=of home] {/bin};
    \node (etc)   [folder, left=of bin] {/etc};
    \node (var)   [folder, right=of home] {/var};
    \node (tmp)   [folder, right=of var] {/tmp};
    
    \node (user)  [folder, below=of home] {/home/user};

    \draw [thick] (root) -- (bin.north);
    \draw [thick] (root) -- (etc.north);
    \draw [thick] (root) -- (home.north);
    \draw [thick] (root) -- (var.north);
    \draw [thick] (root) -- (tmp.north);
    \draw [thick] (home) -- (user);
\end{tikzpicture}
\end{center}
```

### Navegação e Caminhos

Para navegar nesta árvore, utilizamos caminhos. Um **caminho absoluto** começa sempre na raiz (`/`) e descreve a localização completa (ex: `/var/log/syslog`). Um **caminho relativo** descreve a localização em relação ao diretório onde se encontra atualmente.

- **`.` (Ponto):** Refere-se ao diretório atual.
- **`..` (Dois Pontos):** Refere-se ao diretório pai (um nível acima).
- **`~` (Tilde):** Um atalho para o seu diretório pessoal (`/home/utilizador`).

## Comandos Essenciais

### Navegação e Exploração

- **`pwd` (Print Working Directory):** Responde à pergunta "Onde estou?".
- **`cd` (Change Directory):** Permite mudar de diretório. `cd ..` sobe um nível, enquanto `cd ~` regressa a casa.
- **`ls` (List):** Lista o conteúdo de um diretório. 
    - `ls -l` exibe detalhes como tamanho e permissões.
    - `ls -a` mostra ficheiros ocultos (aqueles que começam com um ponto).
- **`Tab` (Auto-completar):** A ferramenta de produtividade mais importante. Escreva o início de um nome e pressione `Tab` para que a *shell* o complete automaticamente.

### Manipulação de Ficheiros

- **`mkdir`:** Cria novos diretórios. Use a flag `-p` para criar subdiretórios aninhados de uma só vez.
- **`touch`:** Cria um ficheiro vazio ou atualiza a data de acesso de um existente.
- **`cp` (Copy):** Copia ficheiros ou diretórios (use `-r` para pastas).
- **`mv` (Move):** Move ou renomeia ficheiros e diretórios.
- **`rm` (Remove):** Apaga ficheiros. **Atenção:** No terminal não existe reciclagem; uma vez apagado com `rm`, o ficheiro é removido permanentemente. Para apagar pastas e o seu conteúdo, use `rm -rf`.

### Visualização e Edição

Para ler ficheiros, temos várias opções. O comando `cat` despeja todo o conteúdo no terminal, o que é útil para ficheiros pequenos. Para ficheiros longos, o `less` permite navegar com calma (pressione `q` para sair). Se precisar apenas de ver o início ou o fim de um ficheiro, use `head` ou `tail`.

Para edição de texto, o **Nano** é o editor mais amigável para iniciantes. No entanto, o **Vim** é o padrão profissional, operando em modos (Inserção para escrever, Normal para comandos). Dominar o Vim exige prática, mas recompensa o utilizador com uma velocidade de edição inigualável.

## Gestão de Utilizadores e Permissões

Linux é um sistema multi-utilizador, o que significa que as permissões são cruciais para a segurança. Existem dois tipos principais de utilizadores: o **utilizador padrão**, com acesso limitado à sua própria área de trabalho, e o **Superutilizador (root)**, que tem poder total sobre o sistema.

### O Modelo de Permissões

Cada ficheiro ou diretório tem três tipos de permissões para três categorias de utilizadores:

1.  **Read (r):** Ler o ficheiro ou listar o diretório.
2.  **Write (w):** Modificar o ficheiro ou criar/apagar ficheiros num diretório.
3.  **Execute (x):** Executar um ficheiro como programa ou entrar num diretório.

Estas permissões são aplicadas ao **Proprietário (Owner)**, ao **Grupo** e aos **Outros**.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1cm,
    box/.style={draw, minimum width=0.8cm, minimum height=0.8cm, font=\ttfamily\small, fill=gray!10, align=center},
    label/.style={font=\sffamily\tiny, align=center}
]
    \node (type)  [box, fill=blue!20] {-};
    \node (u_r)   [box, right=2pt of type] {r};
    \node (u_w)   [box, right=2pt of u_r] {w};
    \node (u_x)   [box, right=2pt of u_w] {x};
    \node (g_r)   [box, right=6pt of u_x] {r};
    \node (g_w)   [box, right=2pt of g_r] {w};
    \node (g_x)   [box, right=2pt of g_w] {x};
    \node (o_r)   [box, right=6pt of g_x] {r};
    \node (o_w)   [box, right=2pt of o_r] {w};
    \node (o_x)   [box, right=2pt of o_w] {x};

    \node[below=2pt of type] [label] {Tipo};
    
    \draw [stealth-stealth] ($(u_r.north west)+(0,0.2)$) -- ($(u_x.north east)+(0,0.2)$) node[midway, above, label] {Proprietário};
    \draw [stealth-stealth] ($(g_r.north west)+(0,0.2)$) -- ($(g_x.north east)+(0,0.2)$) node[midway, above, label] {Grupo};
    \draw [stealth-stealth] ($(o_r.north west)+(0,0.2)$) -- ($(o_x.north east)+(0,0.2)$) node[midway, above, label] {Outros};

\end{tikzpicture}
\end{center}
```

O comando **`chmod`** permite alterar estas permissões. Por exemplo, `chmod u+x script.sh` torna o ficheiro executável para o proprietário.

## Gestão de Pacotes com APT

Nos sistemas baseados em Debian e Ubuntu, o **APT** (*Advanced Package Tool*) é o gestor de pacotes que automatiza a instalação, atualização e remoção de *software*. Ele gere automaticamente as dependências, garantindo que todas as bibliotecas necessárias são instaladas juntamente com o programa desejado.

- **`sudo apt update`:** Sincroniza a lista de pacotes local com os repositórios. Deve ser corrido antes de qualquer instalação.
- **`sudo apt upgrade`:** Atualiza todos os pacotes instalados para a versão mais recente.
- **`sudo apt install <nome>`:** Instala um novo programa.
- **`apt search <termo>`:** Procura por programas disponíveis nos repositórios.

## Automação e Redirecionamento

### Pipes e Redirecionamento

Uma das filosofias fundamentais do Unix é: "Cria programas que façam apenas uma coisa e que a façam bem. Cria programas que trabalhem em conjunto." Isto é possível graças aos fluxos de dados:

- **`>` (Redirecionar Saída):** Guarda o resultado de um comando num ficheiro (sobrescreve).
- **`>>` (Anexar Saída):** Adiciona o resultado ao final de um ficheiro existente.
- **`|` (Pipe):** Liga o resultado de um comando diretamente à entrada do próximo.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    block/.style={draw, rectangle, minimum width=2.5cm, minimum height=1cm, fill=orange!20, font=\ttfamily},
    arrow/.style={-stealth, thick}
]
    \node (cmd1) [block] {Comando A};
    \node (pipe) [circle, draw, fill=blue!20, right=of cmd1] { | };
    \node (cmd2) [block, right=of pipe] {Comando B};
    
    \draw [arrow] (cmd1) -- (pipe);
    \draw [arrow] (pipe) -- (cmd2);
    
    \node [below=0.2cm of cmd1, font=\small\itshape] {Saída Padrão (stdout)};
    \node [below=0.2cm of cmd2, font=\small\itshape] {Entrada Padrão (stdin)};
\end{tikzpicture}
\end{center}
```

Exemplo prático: `ls /etc | grep "conf"` irá listar todos os ficheiros em `/etc` e filtrar apenas aqueles que contêm a palavra "conf".

### Agendamento com Cron

O **Cron** é um serviço que corre em segundo plano e permite agendar tarefas (conhecidas como *cron jobs*). A configuração é feita através do comando `crontab -e`. A sintaxe utiliza cinco campos para definir o momento da execução: minuto, hora, dia do mês, mês e dia da semana.

## Introdução ao Bash Scripting

Um *script* Bash nada mais é do que um ficheiro de texto contendo uma sequência de comandos que a *shell* executará por ordem. Para criar um *script*:

1.  Comece o ficheiro com o *shebang*: `#!/bin/bash`.
2.  Escreva os comandos, um por linha.
3.  Torne o ficheiro executável: `chmod +x o_meu_script.sh`.

Os *scripts* permitem a utilização de variáveis, ciclos (`for`, `while`) e condições (`if`), transformando a linha de comandos numa verdadeira linguagem de programação para administração de sistemas.

## Recursos Adicionais

Para aprofundar os seus conhecimentos na linha de comandos Linux, recomendamos as seguintes fontes:

- **[Linux Journey](https://linuxjourney.com/):** Um guia interativo e gratuito para aprender Linux, desde o básico até à administração de servidores.
- **[Explainshell.com](https://explainshell.com/):** Introduza qualquer comando complexo e este site explicará detalhadamente o que cada parte faz.
- **[Crontab.guru](https://crontab.guru/):** Uma ferramenta visual para validar e criar expressões de agendamento do Cron.
- **[The Linux Command Line (William Shotts)](https://linuxcommand.org/tlcl.php):** Um livro excelente e disponível gratuitamente em formato PDF.
- **[Linux Terminal Cheat Sheet](https://www.geeksforgeeks.org/linux-unix/linux-commands-cheat-sheet/):** Uma folha de consulta rápida com os comandos mais comuns.
- **[Bash Scripting Cheat Sheet](https://developers.redhat.com/cheat-sheets/bash-shell-cheat-sheet):** Guia rápido para as estruturas e sintaxe de scripts Bash.
