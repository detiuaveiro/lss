---
title: Linux terminal
---

# Exercícios

## Exercício 1: A Orientar-se

Este exercício abrange os comandos **`pwd`**, **`ls`**, **`cd`** e comandos básicos de informação.

1.  Abra o seu terminal. Verifique a sua localização inicial (o seu diretório pessoal) imprimindo o diretório de trabalho atual.
    ```bash
    $ pwd
    ```
2.  Liste o conteúdo do seu diretório pessoal. De seguida, liste-o novamente mostrando **todos** os ficheiros no formato de lista **longa**.
    ```bash
    $ ls
    $ ls -la
    ```
3.  Navegue para o diretório de *logs* do sistema em `/var/log` e liste o seu conteúdo.
    ```bash
    $ cd /var/log
    $ ls
    ```
4.  Obtenha alguma informação: descubra o seu nome de utilizador e a data atual.
    ```bash
    $ whoami
    $ date
    ```
5.  Regresse ao seu diretório pessoal usando o atalho mais rápido.
    ```bash
    $ cd ~
    ```

-----

## Exercício 2: A Explorar Diretórios Chave do Sistema

Reforce o seu conhecimento da estrutura do sistema de ficheiros visitando diretórios importantes do sistema.

1.  Navegue para o diretório `/etc`, que contém ficheiros de configuração de todo o sistema.
    ```bash
    $ cd /etc
    ```
2.  Liste o seu conteúdo. Verá muitos ficheiros de configuração.
    ```bash
    $ ls
    ```
3.  Veja o conteúdo do ficheiro `os-release` para obter informação sobre a sua distribuição Linux.
    ```bash
    $ cat os-release
    ```
4.  Agora, navegue para o diretório `/bin` para ver onde muitos dos programas de comandos essenciais estão guardados. Liste o seu conteúdo e veja se reconhece algum.
    ```bash
    $ cd /bin
    $ ls
    ```

-----

## Exercício 3: A Criar e Gerir Ficheiros

Neste exercício, irá criar, copiar, mover e apagar ficheiros e diretórios.

1.  A partir do seu diretório pessoal, crie um novo diretório chamado `IEI`.
    ```bash
    $ cd ~
    $ mkdir IEI
    ```
2.  Navegue para dentro do seu novo diretório `IEI`.
    ```bash
    $ cd IEI
    ```
3.  Crie um ficheiro vazio chamado `notes.txt`.
    ```bash
    $ touch notes.txt
    ```
4.  Adicione texto ao seu ficheiro e depois veja o seu conteúdo.
    ```bash
    $ echo "A minha primeira linha de texto." > notes.txt
    $ cat notes.txt
    ```
5.  Faça uma cópia do seu ficheiro com o nome `notes_backup.txt`.
    ```bash
    $ cp notes.txt notes_backup.txt
    ```
6.  Renomeie `notes.txt` para `important_notes.txt`.
    ```bash
    $ mv notes.txt important_notes.txt
    ```
7.  Faça a limpeza, apagando o ficheiro de *backup*.
    ```bash
    $ rm notes_backup.txt
    ```

-----

## Exercício 4: A Compreender Permissões

Este exercício foca-se na leitura e alteração de permissões de ficheiros com o comando **`chmod`**.

1.  Dentro do seu diretório `~/IEI`, crie um novo ficheiro chamado `secret_data.txt`.
    ```bash
    $ touch secret_data.txt
    ```
2.  Veja as permissões padrão do ficheiro.
    ```bash
    $ ls -l secret_data.txt
    ```
3.  Remova todas as permissões para toda a gente.
    ```bash
    $ chmod 000 secret_data.txt
    ```
4.  Tente ver o conteúdo do ficheiro. Deverá receber um erro de **"Permission denied"**.
    ```bash
    $ cat secret_data.txt
    ```
5.  Restaure a permissão de leitura e escrita **apenas para si**.
    ```bash
    $ chmod u+rw secret_data.txt
    ```
6.  Crie um ficheiro de *script* vazio `my_script.sh` e torne-o executável para si. Verifique as permissões depois para ver a alteração.
    ```bash
    $ touch my_script.sh
    $ chmod u+x my_script.sh
    $ ls -l my_script.sh
    ```

-----

## Exercício 5: A Encontrar Ficheiros e Conteúdo com `find` e `grep`

Aprenda a localizar ficheiros por nome e a procurar por texto dentro deles.

1.  Dentro de `~/IEI`, crie um subdiretório e um novo ficheiro dentro dele.
    ```bash
    $ mkdir -p ~/IEI/reports
    $ echo "Este é um relatório confidencial." > ~/IEI/reports/report-2025.txt
    ```
2.  Use o comando `find` para procurar qualquer ficheiro que termine em `.txt` dentro do seu diretório `IEI`.
    ```bash
    $ find ~/IEI -name "*.txt"
    ```
3.  Use o `grep` para procurar a palavra "confidencial" no seu novo ficheiro de relatório. A *flag* `-i` torna a pesquisa insensível a maiúsculas e minúsculas.
    ```bash
    $ grep -i "confidencial" ~/IEI/reports/report-2025.txt
    ```

-----

## Exercício 6: A Gerir Processos

Aprenda a ver e a parar programas em execução a partir da linha de comandos.

1.  Inicie um processo que irá correr em *background*. O comando `sleep` espera por um número específico de segundos, e o `&` envia-o para *background*.
    ```bash
    $ sleep 120 &
    ```
2.  Encontre o ID do Processo (PID) do comando `sleep`. Pode usar o `pgrep` para isto.
    ```bash
    $ pgrep sleep
    ```
3.  Agora, termine o processo usando o comando `kill` e o PID que acabou de encontrar. Substitua `PID` pelo número real do passo anterior.
    ```bash
    $ kill PID
    ```
4.  Verifique se o processo já não está a correr. O comando `pgrep sleep` agora não deverá devolver nada.
    ```bash
    $ pgrep sleep
    ```

-----

## Exercício 7: A Gerir Software com APT

Vamos instalar e remover um programa usando o gestor de pacotes **APT**.

1.  Primeiro, sincronize a lista de pacotes do seu sistema com os repositórios de *software*.
    ```bash
    $ sudo apt update
    ```
2.  Procure por uma ferramenta de linha de comandos útil chamada `htop`.
    ```bash
    $ apt search htop
    ```
3.  Agora, instale o `htop`. Terá de confirmar a instalação quando solicitado.
    ```bash
    $ sudo apt install htop
    ```
4.  Execute o programa que acabou de instalar. Pressione `q` para sair.
    ```bash
    $ htop
    ```
5.  Finalmente, faça a limpeza removendo o pacote do seu sistema.
    ```bash
    $ sudo apt remove htop
    ```

-----

## Exercício 8: A Combinar Comandos

Vamos explorar o poder do **pipe (`|`)** e do **redirecionamento (`>>`)**.

1.  O comando `ps aux` lista todos os processos em execução. Use o *pipe* (`|`) para enviar este *output* para o `grep` para encontrar o seu próprio processo "bash".
    ```bash
    $ ps aux | grep "bash"
    ```
2.  Crie um ficheiro de *log* com uma entrada.
    ```bash
    $ echo "$(date): A iniciar o meu trabalho." > ~/IEI/activity.log
    ```
3.  Use o operador de acréscimo (`>>`) para adicionar uma segunda linha ao ficheiro sem apagar a primeira.
    ```bash
    $ echo "$(date): Terminado o exercício 8." >> ~/IEI/activity.log
    ```
4.  Verifique se o seu ficheiro de *log* contém ambas as linhas.
    ```bash
    $ cat ~/IEI/activity.log
    ```

-----

## Exercício 9: A Personalizar o Seu Ambiente

É hora de editar o seu ficheiro **`.bashrc`** para criar um atalho útil (um *alias*).

1.  Abra o seu ficheiro `~/.bashrc` usando o editor `nano`.
    ```bash
    $ nano ~/.bashrc
    ```
2.  Vá até ao final do ficheiro e adicione a seguinte linha para criar um atalho `ll` para o comando `ls -alF`.
    ```bash
    alias ll='ls -alF'
    ```
3.  Guarde o ficheiro e saia do `nano` (`Ctrl+X`, depois `S`, e de seguida `Enter`).
4.  Carregue as alterações na sua sessão atual.
    ```bash
    $ source ~/.bashrc
    ```
5.  Teste o seu novo *alias*.
    ```bash
    $ ll
    ```

-----

## Exercício 10: A Compreender a Variável `$PATH`

Descubra como a *shell* encontra os comandos que executa.

1.  Veja a variável `$PATH` atual. É uma lista de diretórios separados por dois pontos.
    ```bash
    $ echo $PATH
    ```
2.  Crie um *script* simples de uma linha no seu diretório `~/IEI` e torne-o executável.
    ```bash
    $ echo '#!/bin/bash' > ~/IEI/hello
    $ echo 'echo "Olá do meu script personalizado!"' >> ~/IEI/hello
    $ chmod +x ~/IEI/hello
    ```
3.  Tente executar o *script* pelo nome. Irá falhar porque não está num diretório listado na `$PATH`.
    ```bash
    $ hello
    ```
4.  Agora execute-o usando o seu caminho relativo. Isto funciona.
    ```bash
    $ ./hello
    ```
5.  Adicione temporariamente o seu diretório `~/IEI` à `$PATH`. Agora tente executar o *script* pelo nome novamente.
    ```bash
    $ export PATH="$HOME/IEI:$PATH"
    $ hello
    ```
    Esta alteração dura apenas para a sua sessão de terminal atual.

-----

## Exercício 11: Desafio de Scripting

Vamos criar um *script* que automatiza a criação de uma estrutura de projeto.

1.  Crie e abra um novo ficheiro chamado `setup_project.sh` no seu diretório `~/IEI`. Adicione o código seguinte, e depois guarde e feche o ficheiro.
    ```bash
    #!/bin/bash
    PROJECT_DIR="$HOME/IEI/my_project"

    if [ -d "$PROJECT_DIR" ]; then
      echo "Erro: O diretório '$PROJECT_DIR' já existe."
      exit 1
    fi

    mkdir "$PROJECT_DIR"
    echo "Diretório '$PROJECT_DIR' criado."

    for folder in assets source docs
    do
      mkdir "$PROJECT_DIR/$folder"
      echo "-> Subpasta criada: $folder"
    done

    echo "Configuração do projeto concluída!"
    ```
2.  Torne o *script* executável e depois execute-o.
    ```bash
    $ chmod +x ~/IEI/setup_project.sh
    $ ~/IEI/setup_project.sh
    ```
3.  Verifique se o diretório e os seus subdiretórios foram criados.
    ```bash
    $ ls -R ~/IEI/my_project
    ```

-----

## Exercício 12: A Agendar uma Tarefa com `cron`

Vamos criar um *script* simples e agendá-lo para ser executado automaticamente a cada minuto.

1.  **Crie o Script:** No seu diretório `~/IEI`, crie um *script* chamado `log_time.sh` com o seguinte conteúdo.
    ```bash
    #!/bin/bash
    date >> $HOME/IEI/cron_log.txt
    ```
2.  **Torne-o Executável:**
    ```bash
    $ chmod +x ~/IEI/log_time.sh
    ```
3.  **Abra o seu Crontab:** Isto irá abrir um editor de texto.
    ```bash
    $ crontab -e
    ```
4.  **Adicione o Cron Job:** Vá até ao final do ficheiro e adicione a seguinte linha. Deve usar o caminho completo e absoluto para o seu *script*.
    ```cron
    * * * * * /home/student/IEI/log_time.sh
    ```
5.  **Guarde e Verifique:** Guarde e saia do editor. Espere dois minutos e depois verifique o seu ficheiro de *log*. Deverá ver duas entradas com data e hora.
    ```bash
    $ cat ~/IEI/cron_log.txt
    ```
6.  **Limpeza:** É muito importante remover o *cron job* para que não corra para sempre. Este comando remove todo o seu ficheiro *crontab*.
    ```bash
    $ crontab -r
    ```

-----

## Exercício 13: Ver Ficheiros com `cat`, `less`, `head` e `tail`

Pratique as diferentes formas de inspecionar o conteúdo de ficheiros sem abrir um editor.

1.  Comece por criar um ficheiro com várias linhas para ter algo com que trabalhar.
    ```bash
    $ seq 1 100 > ~/IEI/numbers.txt
    ```
2.  Use o `cat` para despejar todo o ficheiro no ecrã. Repare como passa rapidamente.
    ```bash
    $ cat ~/IEI/numbers.txt
    ```
3.  Agora use o `less` para abrir o mesmo ficheiro num visualizador com *scroll*. Use as **Setas** para navegar e pressione **`q`** para sair.
    ```bash
    $ less ~/IEI/numbers.txt
    ```
4.  Veja apenas as **primeiras 5 linhas** do ficheiro usando `head`.
    ```bash
    $ head -n 5 ~/IEI/numbers.txt
    ```
5.  Veja apenas as **últimas 5 linhas** do ficheiro usando `tail`.
    ```bash
    $ tail -n 5 ~/IEI/numbers.txt
    ```
6.  Combine `head` e `tail` com um *pipe* para extrair **apenas as linhas 45 a 55** do ficheiro.
    ```bash
    $ head -n 55 ~/IEI/numbers.txt | tail -n 11
    ```
7.  Use `wc` (*word count*) para contar o número total de linhas, palavras e caracteres no ficheiro.
    ```bash
    $ wc ~/IEI/numbers.txt
    ```

-----

## Exercício 14: Mergulho na Informação do Sistema

Use o terminal para recolher informação detalhada sobre o *hardware* e os recursos do seu sistema.

1.  Exiba a versão do *kernel* e a arquitetura do sistema.
    ```bash
    $ uname -a
    ```
2.  Verifique a informação do CPU lendo do sistema de ficheiros virtual `/proc`. Filtre o *output* para mostrar apenas o nome do modelo.
    ```bash
    $ cat /proc/cpuinfo | grep "model name"
    ```
3.  Exiba a utilização atual da RAM e Swap num formato legível por humanos.
    ```bash
    $ free -h
    ```
4.  Verifique a utilização de espaço em disco em todos os sistemas de ficheiros montados.
    ```bash
    $ df -h
    ```
5.  Verifique a utilização de disco do seu diretório pessoal especificamente. A *flag* `-s` dá um resumo e `-h` torna-o legível.
    ```bash
    $ du -sh ~
    ```
6.  Se tiver acesso `sudo`, use o `dmidecode` para consultar a informação da BIOS do sistema.
    ```bash
    $ sudo dmidecode -t bios
    ```
7.  Veja as suas interfaces de rede e os seus endereços IP.
    ```bash
    $ ip addr show
    ```

-----

## Exercício 15: Wildcards e Globbing

Aprenda a selecionar múltiplos ficheiros de uma vez usando correspondência de padrões.

1.  Crie um conjunto de ficheiros de teste para trabalhar dentro de um novo diretório.
    ```bash
    $ mkdir -p ~/IEI/wildcard_test
    $ cd ~/IEI/wildcard_test
    $ touch report1.txt report2.txt report3.txt
    $ touch summary.txt data.csv output.csv
    $ touch image1.png image2.png image10.png
    ```
2.  Use o *wildcard* `*` para listar **todos os ficheiros `.txt`**.
    ```bash
    $ ls *.txt
    ```
3.  Use o *wildcard* `*` para listar **todos os ficheiros que começam por `report`**.
    ```bash
    $ ls report*
    ```
4.  Use o *wildcard* `?` para corresponder a ficheiros com **exatamente um caracter** depois de `report`. Repare que `report10.txt` **não** é correspondido.
    ```bash
    $ ls report?.txt
    ```
5.  Use o *wildcard* `?` para corresponder a ficheiros de imagem com um número de **um único dígito**. Repare que `image10.png` é excluído.
    ```bash
    $ ls image?.png
    ```
6.  Liste **todos os ficheiros `.csv`** e redirecione o *output* para um ficheiro chamado `csv_list.txt`.
    ```bash
    $ ls *.csv > csv_list.txt
    $ cat csv_list.txt
    ```
7.  Use *wildcards* para **apagar todos os ficheiros `.csv`** de uma vez e depois verifique que desapareceram.
    ```bash
    $ rm *.csv
    $ ls
    ```
8.  Limpe o diretório de teste.
    ```bash
    $ cd ~
    $ rm -r ~/IEI/wildcard_test
    ```

-----

## Exercício 16: Fluxos de E/S e Redirecionamento de Erros

Compreenda como controlar para onde vão a saída padrão e o erro padrão.

1.  Execute um comando que produz **output normal** (stdout). Redirecione-o para um ficheiro.
    ```bash
    $ echo "Isto é a saída padrão" > ~/IEI/stdout_test.txt
    $ cat ~/IEI/stdout_test.txt
    ```
2.  Execute um comando que irá produzir um **erro** (stderr). Tente listar um diretório que não existe.
    ```bash
    $ ls /diretorio_inexistente
    ```
3.  Redirecione **apenas o erro** para um ficheiro usando `2>`. A mensagem de erro irá para o ficheiro em vez do ecrã.
    ```bash
    $ ls /diretorio_inexistente 2> ~/IEI/errors.log
    $ cat ~/IEI/errors.log
    ```
4.  Agora execute um comando que produz **tanto** stdout como stderr. Use o `find` para pesquisar em `/etc` — alguns diretórios irão produzir erros de "Permission denied".
    ```bash
    $ find /etc -name "*.conf"
    ```
5.  Separe os dois fluxos: guarde os **resultados** num ficheiro e os **erros** noutro.
    ```bash
    $ find /etc -name "*.conf" > ~/IEI/results.txt 2> ~/IEI/find_errors.log
    $ wc -l ~/IEI/results.txt
    $ cat ~/IEI/find_errors.log
    ```
6.  Combine **ambos os fluxos** num único ficheiro usando `2>&1`.
    ```bash
    $ find /etc -name "*.conf" > ~/IEI/all_output.txt 2>&1
    $ wc -l ~/IEI/all_output.txt
    ```
7.  Descarte todo o *output* redirecionando para `/dev/null` (o "buraco negro" do sistema).
    ```bash
    $ find /etc -name "*.conf" > /dev/null 2>&1
    ```

-----

## Exercício 17: Gestão de Utilizadores

Pratique a criação, modificação e remoção de contas de utilizador. Estes comandos requerem `sudo`.

1.  Crie um novo utilizador chamado `testuser`.
    ```bash
    $ sudo useradd testuser
    ```
2.  Verifique se o utilizador foi criado consultando o ficheiro `/etc/passwd`.
    ```bash
    $ grep testuser /etc/passwd
    ```
3.  Defina uma *password* para o novo utilizador. Ser-lhe-á pedido para escrever a *password* duas vezes.
    ```bash
    $ sudo passwd testuser
    ```
4.  Verifique a que grupos o novo utilizador pertence.
    ```bash
    $ groups testuser
    ```
5.  Adicione o utilizador ao grupo `sudo` para que tenha privilégios de administrador.
    ```bash
    $ sudo usermod -aG sudo testuser
    $ groups testuser
    ```
6.  Mude temporariamente para a conta do novo utilizador usando `su`. Escreva `exit` para regressar à sua conta.
    ```bash
    $ su - testuser
    $ whoami
    $ pwd
    $ exit
    ```
7.  Apague o utilizador e o seu diretório pessoal para limpar.
    ```bash
    $ sudo userdel -r testuser
    $ grep testuser /etc/passwd
    ```

-----

## Exercício 18: Permissões Numéricas (Octais) com `chmod`

Aprenda a usar a notação numérica para definir permissões, que é mais rápida do que a notação simbólica para alterações complexas.

Os valores de permissão são: **Leitura (4)**, **Escrita (2)**, **Execução (1)**. Some-os para cada grupo: **Proprietário | Grupo | Outros**.

1.  Crie um ficheiro de teste e um *script* de teste dentro de `~/IEI`.
    ```bash
    $ echo "Dados sensíveis" > ~/IEI/config_file.txt
    $ echo '#!/bin/bash' > ~/IEI/run_me.sh
    $ echo 'echo "Script executado!"' >> ~/IEI/run_me.sh
    ```
2.  Veja as permissões atuais de ambos os ficheiros.
    ```bash
    $ ls -l ~/IEI/config_file.txt ~/IEI/run_me.sh
    ```
3.  Defina `config_file.txt` com a permissão **`644`** (proprietário: leitura+escrita, grupo: leitura, outros: leitura). Esta é a permissão padrão para ficheiros de configuração.
    ```bash
    $ chmod 644 ~/IEI/config_file.txt
    $ ls -l ~/IEI/config_file.txt
    ```
4.  Defina `run_me.sh` com a permissão **`755`** (proprietário: leitura+escrita+execução, grupo: leitura+execução, outros: leitura+execução). Esta é a permissão padrão para *scripts*.
    ```bash
    $ chmod 755 ~/IEI/run_me.sh
    $ ls -l ~/IEI/run_me.sh
    ```
5.  Execute o *script* para confirmar que funciona.
    ```bash
    $ ~/IEI/run_me.sh
    ```
6.  Defina `config_file.txt` com a permissão **`600`** (proprietário: leitura+escrita, todos os outros: nada). Isto é apropriado para ficheiros privados como chaves SSH.
    ```bash
    $ chmod 600 ~/IEI/config_file.txt
    $ ls -l ~/IEI/config_file.txt
    ```
7.  **Desafio:** Que número de permissão daria ao proprietário acesso total, ao grupo acesso de leitura apenas, e aos outros nenhum acesso? Defina-o em `run_me.sh` e verifique.
    ```bash
    $ chmod 740 ~/IEI/run_me.sh
    $ ls -l ~/IEI/run_me.sh
    ```
