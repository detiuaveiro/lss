---
title: Comunicação, Desempenho e Segurança Avançada
---

# Introdução: A Realidade das Redes

## Além do "Plug and Play" I

Nas sessões anteriores, tratámos a rede como um simples fio que liga dois pontos.

* Num ambiente de laboratório ou doméstico, isto funciona frequentemente sem falhas.
* A configuração é mínima e a velocidade é geralmente elevada.
* Este é o cenário "ideal" que raramente existe em ambientes profissionais.

## Além do "Plug and Play" II

As redes do mundo real são complexas, heterogéneas e muitas vezes hostis.

* **Complexidade:** Os dados viajam através de dezenas de routers e switches.
* **Controlo:** As organizações (como universidades) impõem regras estritas ao tráfego.
* **Limitações:** Nem todas as portas estão abertas; nem todos os protocolos são permitidos.
* **Objetivo:** Aprender a navegar, medir e criar pontes nestes sistemas complexos.

## O Exemplo da "eduroam" I

Considere a rede **eduroam** utilizada na Universidade de Aveiro.

* É um serviço global de roaming para investigação e educação.
* É altamente segura, utilizando WPA2-Enterprise para autenticação.
* No entanto, de uma perspetiva de rede, é um ambiente **fechado**.

## O Exemplo da "eduroam" II

Porque é que a eduroam é "fechada" ou "restrita"?

* **Segurança:** Para evitar que malware se espalhe entre milhares de estudantes.
* **Gestão de Recursos:** Para garantir que um utilizador não consome toda a largura de banda.
* **Filtragem de Portas:** Frequentemente, apenas portas comuns como 80 (HTTP) e 443 (HTTPS) estão abertas.
* **O Problema:** Como correr uma base de dados personalizada ou um servidor de jogos numa rede tão restrita?

# Parte I: Análise de Desempenho de Rede

## Porquê Medir o Desempenho? I

"A rede está lenta" é a queixa mais comum em TI.

* Para um estudante, significa que o Netflix está a fazer buffering.
* Para uma empresa, significa perder milhares de euros por minuto.
* Para um engenheiro, é uma **métrica** que deve ser quantificada.

## Porquê Medir o Desempenho? II

Medimos o desempenho para:

* **Validar a Infraestrutura:** O hardware cumpre as especificações?
* **Resolver Problemas:** O problema está no Wi-Fi local ou no ISP global?
* **Planeamento:** Quando precisamos de atualizar os nossos links?
* **Benchmarks:** Comparar diferentes protocolos (ex: TCP vs UDP).

## Métricas Chave: Largura de Banda (Bandwidth)

**Largura de Banda** é frequentemente confundida com "velocidade".

* Representa a **capacidade máxima** do canal de comunicação.
* Analogia: O número de faixas numa autoestrada.
* Unidade: bits por segundo (bps, Mbps, Gbps).
* Ter 1Gbps de largura de banda não garante que a sua transferência seja assim tão rápida.

## Métricas Chave: Débito (Throughput)

**Débito** é a quantidade real de dados entregues com sucesso.

* É a velocidade do "mundo real" que você experiencia.
* É sempre menor ou igual à largura de banda.
* Influenciado por: Overhead de protocolos, erros e congestão.
* Analogia: O número real de carros que passam num ponto por segundo.

## Métricas Chave: Latência

**Latência** é o atraso de tempo entre um pedido e uma resposta.

* Frequentemente chamada de "ping" ou RTT (Round Trip Time).
* Crítica para aplicações em tempo real (Jogos, VoIP, Videochamadas).
* Latência elevada faz com que um link rápido (alta largura de banda) pareça "pesado".
* Analogia: O tempo que um carro demora a ir de Aveiro a Lisboa.

## Métricas Chave: Jitter

**Jitter** é a variação da latência ao longo do tempo.

* Se um pacote demora 20ms e o seguinte 100ms, tem jitter elevado.
* Causa "soluços" em fluxos de vídeo e áudio.
* O buffering é a solução comum para mascarar o jitter.

## Medir a Capacidade: `iperf3` I

O `iperf3` é a ferramenta utilizada para determinar o limite "real" de um link.

* Elimina variáveis como a velocidade do disco ou processamento do browser.
* Testa puramente a stack de rede.
* Requer dois pontos: um **Servidor** e um **Cliente**.

## Medir a Capacidade: `iperf3` II

Porque não usar apenas um "Speedtest" na web?

* **Controlo:** O `iperf3` permite escolher o protocolo (TCP, UDP, SCTP).
* **Direção:** Pode testar upload e download separadamente ou em simultâneo.
* **Duração:** Pode correr testes durante horas para encontrar quebras intermitentes.
* **Precisão:** Fornece dados técnicos brutos, não uma "barra" simplificada.

## Testes TCP vs. UDP com `iperf3`

* **Teste TCP:** Mede quão bem a rede lida com dados fiáveis e ordenados.
  * `iperf3 -c <ip>`
* **Teste UDP:** Mede o débito bruto e a perda de pacotes.
  * `iperf3 -c <ip> -u -b 100M`
  * Importante: O UDP não abranda quando a rede está cheia; apenas perde pacotes.

# Parte II: Diagnóstico de Rede

## A Mentalidade de Diagnóstico

Quando a comunicação falha, seguimos o caminho do pacote.

* Começamos no **Host Local** (Interface/IP).
* Passamos para a **Gateway Local** (Router).
* Atravessamos a **Rede do ISP**.
* Chegamos ao **Destino Remoto**.

## Ferramenta de Diagnóstico: `ping`

A ferramenta mais básica, mas essencial.

* Utiliza o protocolo **ICMP** (Internet Control Message Protocol).
* "Estás aí?" -> "Sim, estou."
* Diz-nos duas coisas: **Alcançabilidade** e **Latência**.
* **Aviso:** Em redes como a eduroam, muitos servidores bloqueiam o `ping` por segurança.

## Ferramenta de Diagnóstico: `traceroute` I

Quando o `ping` funciona mas o serviço é lento, precisamos de ver o caminho.

* Mostra cada router ("salto" ou hop) entre si e o destino.
* Como funciona: Envia pacotes com um "Time to Live" (TTL) baixo.
* Cada router reduz o TTL. Quando chega a 0, o router envia um erro de volta.
* Estes erros dizem-nos a identidade do router.

## Ferramenta de Diagnóstico: `traceroute` II

* **Limitação:** O `traceroute` padrão é uma foto estática.
* Apenas mostra o caminho para aqueles pacotes específicos naquele momento.
* Em redes dinâmicas, os caminhos podem mudar constantemente.

## Diagnóstico Avançado: `mtr` I

O `mtr` (My Traceroute) é o `ping` e o `traceroute` combinados em esteroides.

* Não corre apenas uma vez; sonda o caminho **continuamente**.
* Constrói uma tabela dinâmica de estatísticas para cada router no caminho.
* Mostra a **% de Perda de Pacotes** em cada fase.

## Diagnóstico Avançado: `mtr` II

* **Justificação:** Se vir 0% de perda nos saltos 1 e 2, mas 50% de perda no salto 3, sabe exatamente onde está o estrangulamento.
* Essencial para reportar problemas a administradores de rede.
* Comando: `mtr google.com`

## Inspeção de Pacotes: `tcpdump` I

Quando os diagnósticos dizem que o "tubo" está bem, mas a aplicação falha.

* Precisamos de inspecionar o **conteúdo** da comunicação.
* O `tcpdump` é um analisador de pacotes por linha de comando.
* Captura pacotes diretamente da interface de rede.
* Permite ver se o "handshake" está a ocorrer ou se os dados estão corrompidos.

## Inspeção de Pacotes: `tcpdump` II

Porque usar o `tcpdump` em vez do Wireshark gráfico?

* **Acesso Remoto:** A maioria dos servidores não tem interface gráfica.
* **Eficiência:** O `tcpdump` usa muito pouca memória e CPU.
* **Automação:** Pode criar scripts para o `tcpdump` iniciar quando ocorre um evento.
* **Privacidade:** Pode filtrar para ver apenas os cabeçalhos (metadados) sem o conteúdo.

# Parte III: Eficiência de Comunicação

## O Custo da Comunicação

A transferência de dados não é gratuita.

* **Tempo:** Backups grandes podem demorar horas ou dias.
* **Dinheiro:** Fornecedores de cloud cobram pelo tráfego de saída (egress).
* **Energia:** Mover dados pelo globo consome eletricidade significativa.
* **Fiabilidade:** Quanto mais tempo demora uma transferência, maior a chance de falha.

## Melhorar o Modelo: `rsync` I

O modelo tradicional (SCP/FTP) é "Copiar Tudo".

* Se tem um ficheiro de 1GB e muda 1 linha, envia 1GB novamente.
* Isto é extremamente ineficiente.
* **O Modelo `rsync`:** "Apenas Copiar as Diferenças".

## Melhorar o Modelo: `rsync` II

Como é que o `rsync` sabe o que mudou?

* Utiliza um algoritmo de **checksum** para comparar blocos de ficheiros.
* Apenas os blocos que são diferentes são transmitidos.
* Comprime os dados "na hora" antes de os enviar.
* Pode preservar todos os metadados (permissões, donos, tempos).

## `rsync` no Mundo Real

* **Backups:** Manter uma pasta local idêntica a um servidor remoto.
* **Deployment de Sites:** Enviar apenas os ficheiros HTML/CSS atualizados para o servidor.
* **Retomar:** Se a ligação cair aos 90%, o `rsync` recomeça de onde parou.
* Comando: `rsync -avz --progress ./local/ utilizador@remoto:/dados/`

# Parte IV: Túneis e Pontes Seguras

## O Problema da Firewall

Em redes como a **eduroam**, você está muitas vezes preso atrás de uma firewall rígida.

* Quer aceder ao seu PC de casa (porta 22). **Bloqueado.**
* Quer aceder a uma base de dados privada (porta 5432). **Bloqueado.**
* Apenas o tráfego web "padrão" (80/443) é permitido.

## A Solução por Túnel

Um **Túnel** é uma forma de envolver um protocolo proibido dentro de um permitido.

* Utilizamos o **SSH** (Secure Shell) como "envelope".
* Como o tráfego SSH é encriptado, a firewall não consegue ver o que está lá dentro.
* Vê "tráfego SSH" e permite-o. Lá dentro, podemos estar a correr qualquer coisa.

## Local Port Forwarding (`-L`) I

"Trazer o serviço remoto até mim."

* Você está na Universidade (eduroam).
* Precisa de aceder a um servidor em casa que não é público.
* Você "tunela" a porta remota para a sua máquina local.

## Local Port Forwarding (`-L`) II

* **Exemplo:** `ssh -L 8080:localhost:5432 utilizador@casa-server`
* Agora, abre o seu browser local em `localhost:8080`.
* O tráfego vai pelo túnel SSH e atinge a base de dados em casa.
* Para a rede da Universidade, você está apenas a "usar SSH".

## Remote Port Forwarding (`-R`) I

"Expor a minha máquina local para o mundo."

* Está a desenvolver um site no seu portátil.
* Quer que um amigo o veja, mas não tem IP público.
* Você tunela a sua porta local para um servidor público.

## Remote Port Forwarding (`-R`) II

* **Exemplo:** `ssh -R 8080:localhost:80 utilizador@servidor-publico`
* O seu amigo acede a `http://servidor-publico:8080`.
* O pedido viaja pelo túnel até ao seu portátil.
* Isto contorna o NAT/Firewall da rede onde você se encontra.

## Dynamic Port Forwarding (`-D`) I

"Usar o servidor remoto como os meus olhos." (O Proxy SOCKS).

* Em algumas redes, certos sites podem estar bloqueados.
* Ou quer navegar na web como se estivesse noutro país.
* Um túnel dinâmico transforma a sua ligação SSH num **Proxy**.

## Dynamic Port Forwarding (`-D`) II

* **Exemplo:** `ssh -D 1080 utilizador@servidor-remoto`
* Configura o seu browser (ex: Firefox) para usar um "Proxy SOCKS5" em `localhost:1080`.
* Agora, cada site que visita vê o IP do **servidor remoto**, não o seu.
* Esta é uma "VPN de pobre" que é muito eficaz.

# Parte V: Redes Privadas Virtuais (VPNs)

## Túnel vs. VPN

* **Túnel:** Liga portas específicas. (Granular).
* **VPN:** Liga redes inteiras. (Transparente).
* Uma VPN cria uma interface de rede virtual (ex: `tun0`) no seu computador.
* Todo o seu tráfego é automaticamente encaminhado pelo túnel encriptado.

## Porquê usar uma VPN?

* **Segurança:** Protege os seus dados em Wi-Fi público.
* **Acesso:** Junte-se à rede da Universidade a partir de casa para aceder a recursos da biblioteca.
* **Privacidade:** Esconde a sua atividade do seu ISP.
* **Acesso Global:** Aceder a conteúdos restritos a certas regiões.

## Protocolos VPN: OpenVPN

* **Características:** Extremamente flexível e robusto.
* **Compatibilidade:** Funciona em quase todos os dispositivos.
* **Complexidade:** Base de código grande e difícil de configurar manualmente.
* **Desempenho:** Pode ser lento devido ao elevado overhead.

## Protocolos VPN: WireGuard

* **Características:** O padrão moderno para VPNs.
* **Velocidade:** Extremamente rápido com latência muito baixa.
* **Simplicidade:** Base de código muito pequena (mais fácil de auditar).
* **Moderno:** Utiliza criptografia de última geração.
* Integrado no kernel do Linux para máximo desempenho.

# Parte VI: Infraestrutura Avançada

## Equilíbrio de Carga I

O que acontece quando o seu serviço é demasiado popular?

* Milhares de utilizadores tentam ligar-se a um único servidor.
* O CPU chega aos 100% e a memória enche.
* O serviço crasha.

## Equilíbrio de Carga II

Um **Equilibrador de Carga** (como o NGINX) é o ponto de entrada.

* Fica à frente de um grupo de servidores (um "cluster").
* Recebe todas as ligações de entrada.
* Decide qual o servidor menos ocupado e encaminha o tráfego.
* Se um servidor falhar, o equilibrador para de lhe enviar tráfego (Alta Disponibilidade).

## Prevenção de Intrusões: `fail2ban` I

No momento em que coloca um servidor na internet, ele é atacado.

* Scripts (bots) tentarão entrar usando passwords comuns.
* Isto é chamado de ataque de "Força Bruta".
* Mesmo que não entrem, consomem recursos do seu servidor.

## Prevenção de Intrusões: `fail2ban` II

O `fail2ban` é o segurança automatizado.

* Monitoriza os logs dos seus serviços (SSH, Web, etc.).
* Se um IP falhar o login 5 vezes seguidas, o `fail2ban` bloqueia-o.
* Atualiza a sua **Firewall** (iptables/nftables) para descartar todos os pacotes desse IP.
* Isto torna o ataque ao seu servidor muito mais difícil e caro para o hacker.

# Resumo

## Resumo

* **Medição:** Usar `iperf3` e `mtr` para quantificar a qualidade da sua rede.
* **Sincronização:** Usar `rsync` para mover dados de forma eficiente e fiável.
* **Pontes:** Usar Túneis SSH para contornar firewalls e alcançar serviços isolados.
* **Expansão:** Usar VPNs (WireGuard) para se juntar com segurança a redes remotas.
* **Resiliência:** Usar Equilibradores de Carga e `fail2ban` para proteger e escalar os seus serviços.
