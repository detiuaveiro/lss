# Infraestrutura, Desempenho e Segurança de Redes

## Introdução

A transição de um ambiente de laboratório para a infraestrutura de rede do mundo real revela uma disparidade significativa. Enquanto em contextos domésticos a conectividade é frequentemente vista como um serviço "plug and play", em ambientes profissionais e académicos — como a rede **eduroam** — a realidade é marcada pela complexidade, heterogeneidade e restrições rigorosas. Nestes cenários, a rede não é apenas um meio de transporte, mas um sistema governado por políticas de segurança, filtragem de portas e gestão de recursos. Para o engenheiro, o desafio reside em saber medir a performance, diagnosticar falhas de forma sistemática e criar pontes seguras para contornar limitações infraestruturais.

---

## Parte 1: Análise de Desempenho de Rede

### Métricas Fundamentais

A frase "a rede está lenta" é imprecisa. Para resolver problemas de conectividade, é necessário quantificar o desempenho através de métricas específicas:

*   **Largura de Banda (*Bandwidth*):** Representa a capacidade máxima teórica de um canal de comunicação (ex: 1 Gbps). É a medida do "tamanho do tubo".
*   **Débito (*Throughput*):** É a quantidade real de dados entregues com sucesso por unidade de tempo. É sempre inferior ou igual à largura de banda, sendo afetado por colisões, erros e *overhead* de protocolos.
*   **Latência:** O tempo de atraso entre o envio de um pedido e a receção da resposta (medido como *Round Trip Time* - RTT). É a métrica crítica para aplicações de tempo real (VoIP, Jogos).
*   **Jitter:** A variação da latência ao longo do tempo. Um jitter elevado causa instabilidade em fluxos de áudio e vídeo, exigindo a implementação de *buffering* para suavizar a entrega.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=2cm,
    pipe/.style={draw, rectangle, minimum width=6cm, minimum height=0.6cm, fill=blue!5},
    arrow/.style={-stealth, thick},
    label/.style={font=\sffamily\tiny}
]
    % Pipe 1: Bandwidth
    \node (p1) [pipe] {};
    \node [above=0.1cm of p1, font=\sffamily\small\bfseries] {Largura de Banda (Capacidade Teórica)};
    \draw [arrow] (-3,0) -- (3,0);
    \node at (0,-0.4) [label] {Analogia: Número de faixas na autoestrada};

    % Pipe 2: Throughput
    \node (p2) [pipe, below=1.5cm of p1] {};
    \node [above=0.1cm of p2, font=\sffamily\small\bfseries] {Débito (Fluxo Real)};
    \draw [arrow] (-2,0) -- (2,0);
    \node at (0,-0.4) [label] {Analogia: Fluxo real de veículos (afetado por trânsito/acidentes)};

    % Latency
    \node (l1) [circle, draw, fill=red!10, below=1.5cm of p2] {$\Delta t$};
    \node [right=0.2cm of l1, font=\sffamily\small\bfseries] {Latência (Tempo de Viagem)};
    \node at (0,-1.1) [label] {Analogia: Tempo de percurso entre a Origem e o Destino};
\end{tikzpicture}
\end{center}
```

### Medição com `iperf3`

Para medir a capacidade real de um link, a ferramenta padrão é o `iperf3`. Ao contrário de testes web, o `iperf3` opera num modelo Cliente-Servidor, eliminando variáveis como a velocidade do disco rígido ou a renderização do browser.

*   **Testes TCP:** Medem a performance de fluxos fiáveis e ordenados.
*   **Testes UDP:** Medem o débito bruto e a perda de pacotes. Como o UDP não possui mecanismos de controlo de congestionamento, ele é ideal para testar o limite físico da rede, embora resulte em perda de pacotes quando a capacidade é excedida.

---

## Parte 2: Diagnóstico de Rede

### A Metodologia de Isolamento

O diagnóstico eficiente segue a trajetória do pacote. Quando uma ligação falha, a análise deve ser feita de forma incremental:
$\text{Host Local} \to \text{Gateway Local} \to \text{Rede do ISP} \to \text{Destino Remoto}$.

### Ferramentas de Sondagem

1.  **`ping`:** Utiliza o protocolo **ICMP** para verificar a alcançabilidade e a latência. É a primeira linha de teste, embora possa ser bloqueado por firewalls.
2.  **`traceroute`:** Mapeia o caminho percorrido, identificando cada salto (*hop*). Utiliza o campo *Time To Live* (TTL) dos pacotes para forçar os routers intermediários a responderem.
3.  **`mtr` (My Traceroute):** Combina a funcionalidade do `ping` e `traceroute` de forma contínua. Permite identificar exatamente em qual salto ocorre a perda de pacotes, sendo indispensável para reportar falhas a administradores de rede.
4.  **`tcpdump`:** Um analisador de pacotes por linha de comando. É utilizado quando a conectividade existe, mas a aplicação falha, permitindo inspecionar o *handshake* TCP ou a integridade dos dados.

---

## Parte 3: Eficiência de Comunicação

### O Custo do Movimento de Dados

A transferência de grandes volumes de dados implica custos em tempo, energia e, em ambientes de nuvem, custos financeiros (*egress fees*). A eficiência na comunicação é, portanto, um requisito de engenharia.

### Otimização com `rsync`

Enquanto protocolos como SCP ou FTP copiam a totalidade de um ficheiro, o **`rsync`** implementa um algoritmo de sincronização baseado em *checksums*. Ele identifica apenas os blocos de dados que foram alterados e transmite exclusivamente essas diferenças (*deltas*), comprimindo os dados durante o transporte.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.2cm,
    box/.style={draw, rectangle, minimum width=2.5cm, minimum height=0.8cm, align=center, font=\sffamily\small},
    arrow/.style={-stealth, thick}
]
    % Traditional Copy
    \node (src1) [box, fill=gray!10] {Ficheiro Local (1GB)};
    \node (dest1) [box, fill=gray!10, right=3cm of src1] {Ficheiro Remoto};
    \draw [arrow] (src1) -- (dest1) node[midway, above, font=\tiny] {Copia tudo (1GB)};

    % Rsync Copy
    \begin{scope}[yshift=-2cm]
        \node (src2) [box, fill=blue!10] {Ficheiro Local (1GB)};
        \node (dest2) [box, fill=blue!10, right=3cm of src2] {Ficheiro Remoto};
        \draw [arrow] (src2) -- (dest2) node[midway, above, font=\tiny] {Copia apenas Deltas (1MB)};
        \node [below=0.2cm of src2, font=\itshape\tiny] {Modelo Tradicional};
        \node [below=0.2cm of dest2, font=\itshape\tiny] {Modelo Rsync};
    \end{scope}
\end{tikzpicture}
\end{center}
```

---

## Parte 4: Túneis e Pontes Seguras

### Contornando a Firewall com SSH

Em redes restritas, a maioria das portas está bloqueada, permitindo apenas tráfego web (80/443) ou SSH (22). Um **Túnel SSH** permite encapsular protocolos proibidos dentro de uma ligação SSH encriptada, tornando o tráfego invisível para a firewall.

*   **Local Port Forwarding (`-L`):** "Traz" um serviço remoto para o localhost. Exemplo: aceder a uma base de dados remota na porta 5432 através da porta local 8080.
*   **Remote Port Forwarding (`-R`):** "Expõe" um serviço local para o mundo exterior via um servidor público. Ideal para demonstrações de projetos em desenvolvimento local.
*   **Dynamic Port Forwarding (`-D`):** Transforma a ligação SSH num **Proxy SOCKS**. Todo o tráfego do browser é encaminhado através do servidor remoto, alterando o IP de saída.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.5cm,
    block/.style={draw, rectangle, minimum width=2cm, minimum height=1cm, align=center, font=\sffamily\small},
    tunnel/.style={draw, cylinder, shape border rotate=90, fill=orange!10, minimum width=4cm, minimum height=1.5cm, align=center, font=\sffamily\small},
    arrow/.style={-stealth, thick}
]
    \node (client) [block, fill=blue!10] {Cliente \\ \tiny{localhost:8080}};
    \node (server) [block, fill=blue!10, right=5cm of client] {Servidor Remoto \\ \tiny{Porta 5432}};
    \node (ssh) [tunnel, right=0.5cm of client] {Túnel SSH \\ \tiny{Encriptado}};

    \draw [arrow] (client) -- (ssh);
    \draw [arrow] (ssh) -- (server);
    
    \node [above=0.5cm of ssh, font=\sffamily\small\bfseries] {Encapsulamento de Protocolo};
\end{tikzpicture}
\end{center}
```

---

## Parte 5: Redes Privadas Virtuais (VPNs)

Enquanto os túneis SSH são granulares (portas específicas), a **VPN (Virtual Private Network)** liga redes inteiras. Ela cria uma interface virtual (ex: `tun0`) e encaminha todo o tráfego do sistema através de um túnel encriptado.

*   **OpenVPN:** Robusto e flexível, mas com elevado *overhead* de processamento.
*   **WireGuard:** O padrão moderno. Implementado no kernel do Linux, oferece performance superior, latência mínima e uma base de código reduzida, facilitando a auditoria de segurança.

---

## Parte 6: Infraestrutura Avançada

### Escalabilidade e Resiliência

Para suportar altas cargas de utilizadores, utiliza-se o **Equilíbrio de Carga (*Load Balancing*)**. Um equilibrador (como o NGINX) distribui as requisições entre um cluster de servidores, garantindo a **Alta Disponibilidade**: se um servidor falhar, o tráfego é redirecionado automaticamente para os restantes.

### Segurança Ativa com `fail2ban`

A exposição de servidores à Internet atrai ataques de "Força Bruta". O **`fail2ban`** atua como um sistema de prevenção de intrusões automático:
1. Monitoriza os logs do sistema em busca de falhas repetidas de login.
2. Ao atingir um limite, atualiza dinamicamente as regras da firewall (`iptables`/`nftables`).
3. Bloqueia o endereço IP do atacante por um período determinado, mitigando o impacto dos bots.

---


## Guia de Diagnóstico de Rede

Para resolver problemas de conectividade, utilize a seguinte matriz de decisão:

| Sintoma | Ferramenta | Métrica Chave | Objetivo |
| :--- | :--- | :--- | :--- |
| Host inacessível | `ping` | RTT / Loss % | Validar conectividade básica (L3) |
| Lentidão intermitente | `mtr` | Loss per Hop | Identificar salto problemático na WAN |
| Porta fechada/bloqueada | `nmap` | State (Open/Filtered) | Verificar regras de Firewall |
| Erro na aplicação | `tcpdump` | Packet Flags/Payload | Analisar Handshake TCP e Retransmissões |
| Performance de Link | `iperf3` | Throughput (Mbps) | Medir capacidade real do canal |

---

## Recursos Adicionais


*   **Medição de Rede:** [iPerf3 Documentation](https://iperf.fr/).
*   **Diagnóstico:** [MTR - My Traceroute](https://github.com/traviscross/mtr).
*   **VPNs Modernas:** [WireGuard Project](https://www.wireguard.com/).
*   **Segurança:** [Fail2Ban Wiki](https://github.com/fail2ban/fail2ban/wiki).
