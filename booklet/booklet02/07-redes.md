# Fundamentos de Redes Informáticas

## Introdução

As redes de computadores constituem o tecido invisível que sustenta a infraestrutura do mundo moderno. O que outrora era visto como a interconexão de terminais de computação evoluiu para um ecossistema onipresente onde praticamente todos os objetos — de eletrodomésticos a veículos e infraestruturas urbanas — estão conectados. Esta interconectividade é a base de serviços essenciais como a computação em nuvem (*Cloud Computing*), o comércio eletrónico e a Internet das Coisas (IoT). Para qualquer profissional de tecnologia, a compreensão profunda de como os dados transitam entre sistemas não é apenas uma vantagem técnica, mas uma competência fundamental para a construção de sistemas resilientes, escaláveis e seguros.

---

## Parte 1: Os Blocos de Construção

### Hardware de Rede

A construção de uma rede começa com a escolha do hardware adequado, onde cada dispositivo desempenha um papel específico na gestão do tráfego de dados.

*   **Hubs:** Dispositivos rudimentares que operam apenas na camada física. Um hub recebe um pacote numa porta e retransmite-o para *todas* as outras portas, independentemente do destinatário. Esta abordagem gera um tráfego excessivo e colisões frequentes, tornando-os obsoletos em redes modernas.
*   **Switches:** Dispositivos inteligentes utilizados em Redes Locais (LAN). Ao contrário dos hubs, o switch aprende os endereços MAC dos dispositivos conectados a cada porta e encaminha os pacotes apenas para o destino pretendido, otimizando a largura de banda.
*   **Routers:** Atuam como gateways entre redes diferentes. Enquanto o switch liga dispositivos dentro de uma LAN, o router interliga a LAN privada com a WAN (*Wide Area Network*), como a Internet.
*   **Access Points (AP):** Funcionam como pontes entre o meio sem fios (Wi-Fi) e a infraestrutura cablada (Ethernet).
*   **ONT (Optical Network Terminal):** Essencial em ligações de fibra ótica, este dispositivo converte os sinais de luz provenientes do cabo de fibra em sinais elétricos processáveis por um router Ethernet.

### O Sistema de Endereçamento: MAC vs. IP

Para que a comunicação ocorra, cada interface de rede deve ser identificável por dois tipos de endereços: um físico e um lógico.

1.  **Endereço MAC (Media Access Control):** É um identificador físico de 48 bits, gravado permanentemente no hardware pelo fabricante. É utilizado para a comunicação dentro de um mesmo segmento de rede (LAN).
2.  **Endereço IP (Internet Protocol):** É um identificador lógico atribuído dinamicamente ou estaticamente. O IPv4 utiliza 32 bits, enquanto o IPv6 utiliza 128 bits. O IP é fundamental para o roteamento entre redes distintas (WAN).

Uma analogia útil é pensar no endereço MAC como o número do passaporte de um indivíduo (identidade permanente) e no endereço IP como a sua morada atual (localização lógica que pode mudar).

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.5cm and 2cm,
    box/.style={draw, rectangle, minimum width=3cm, minimum height=1cm, align=center, font=\sffamily\small},
    arrow/.style={-stealth, thick}
]
    % Nodes
    \node (deviceA) [box, fill=blue!10] {Dispositivo A \\ \tiny{MAC: 00:1A...} \\ \tiny{IP: 192.168.1.10}};
    \node (switch) [box, fill=green!10, right=of deviceA] {Switch \\ \tiny{Tabela MAC}};
    \node (deviceB) [box, fill=blue!10, right=of switch] {Dispositivo B \\ \tiny{MAC: 00:AB...} \\ \tiny{IP: 192.168.1.15}};

    % Flow
    \draw [arrow] (deviceA) -- (switch) node[midway, above, font=\tiny] {Pacote (Dest: IP .15)};
    \draw [arrow] (switch) -- (deviceB) node[midway, above, font=\tiny] {Encaminha via MAC};
    
    \node [below=0.5cm of switch, font=\itshape\tiny] {Comunicação Local (Camada 2)};
\end{tikzpicture}
\end{center}
```

### Resolução de Endereços: ARP

O problema fundamental da rede local é que, embora as aplicações utilizem endereços IP, o hardware (Switch) comunica através de endereços MAC. O **Protocolo de Resolução de Endereços (ARP)** resolve este conflito. Quando um dispositivo deseja enviar dados para um IP na mesma LAN, ele emite um *broadcast* perguntando: "Quem possui este endereço IP?". O dispositivo detentor do IP responde com o seu endereço MAC, que é então armazenado numa **Tabela ARP** local para otimizar comunicações futuras.

### Endereçamento IPv4, Sub-redes e Portas

Um endereço IPv4 é sempre acompanhado por uma **Máscara de Sub-rede**. Esta máscara define qual parte do endereço pertence à rede (identificador da "rua") e qual parte pertence ao host (número da "porta").

Existem intervalos especiais de endereços:
*   **Loopback (`127.0.0.1`):** Utilizado para testar serviços localmente.
*   **Endereços Privados:** Intervalos como `192.168.x.x` que não são roteáveis na Internet pública, sendo usados exclusivamente em LANs.

Finalmente, para que os dados cheguem à aplicação correta dentro de um computador, utilizamos as **Portas**. Enquanto o IP identifica a máquina, a porta identifica o serviço (ex: Porta 80 para HTTP, 443 para HTTPS, 22 para SSH).

---

## Parte 2: O Mundo Alargado (WAN)

### Sair da LAN: Gateway e Roteamento

Quando um dispositivo detecta, através da máscara de sub-rede, que o destino está numa rede externa, ele envia o pacote para o **Default Gateway** (geralmente o router). O router, por sua vez, utiliza tabelas de roteamento para determinar o caminho mais eficiente através da WAN, saltando entre múltiplos routers até atingir o destino.

### NAT e DNS: Os Facilitadores da Internet

Devido à escassez de endereços IPv4, surgiu o **NAT (Network Address Translation)**. O NAT permite que múltiplos dispositivos de uma rede privada partilhem um único endereço IP público, funcionando como um rececionista que gere as correspondências de entrada e saída.

Para evitar que os utilizadores tenham de memorizar IPs numéricos, o **DNS (Domain Name System)** traduz nomes de domínio (ex: `google.com`) em endereços IP. Complementarmente, o **mDNS** permite a descoberta de serviços locais sem a necessidade de um servidor central, enquanto o **DDNS** atualiza automaticamente domínios quando o IP público de uma residência muda.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.5cm,
    block/.style={draw, rectangle, minimum width=2.5cm, minimum height=1cm, align=center, font=\sffamily\small},
    cloud/.style={draw, ellipse, fill=gray!10, minimum width=3cm, minimum height=1.5cm, align=center, font=\sffamily\small},
    arrow/.style={-stealth, thick}
]
    % Nodes
    \node (pc) [block, fill=blue!10] {PC Local \\ \tiny{192.168.1.10}};
    \node (router) [block, fill=green!10, right=of pc] {Router (NAT) \\ \tiny{IP Público}};
    \node (dns) [block, fill=yellow!10, above=of router] {Servidor DNS};
    \node (web) [cloud, right=of router] {Web Server \\ \tiny{8.8.8.8}};

    % Flow
    \draw [arrow] (pc) -- (router);
    \draw [arrow] (router) -- (dns) node[midway, left, font=\tiny] {Query: google.com};
    \draw [arrow] (dns) -- (router) node[midway, right, font=\tiny] {Resposta: 8.8.8.8};
    \draw [arrow] (router) -- (web) node[midway, above, font=\tiny] {Pedido HTTP};
\end{tikzpicture}
\end{center}
```

---

## Parte 3: Protocolos de Aplicação

Os protocolos são conjuntos de regras que definem como as aplicações comunicam.

*   **Web:** O **HTTP** é a base da web, enquanto o **HTTPS** adiciona uma camada de encriptação SSL/TLS para garantir a privacidade e integridade dos dados.
*   **Email:** O envio é feito via **SMTP**, enquanto a receção ocorre via **POP3** (descarregamento) ou **IMAP** (sincronização moderna).
*   **Gestão e Ficheiros:** O **SSH** fornece acesso remoto seguro via linha de comandos. Para ficheiros, o **SFTP** (SSH File Transfer Protocol) é a alternativa segura ao antigo e inseguro FTP.
*   **IoT:** O **MQTT** utiliza um modelo de *Publish/Subscribe*, sendo ideal para sensores com recursos limitados e redes instáveis.

---

## Parte 4: Gestão e Diagnóstico

### Configuração e DHCP

A maioria dos dispositivos obtém a sua configuração de rede via **DHCP (Dynamic Host Configuration Protocol)**. O processo segue quatro etapas: **Discover** (o cliente procura um servidor), **Offer** (o servidor oferece um IP), **Request** (o cliente aceita o IP) e **ACK** (o servidor confirma). O IP é concedido através de um *lease* (concessão) temporal.

### Ferramentas de Diagnóstico

O diagnóstico de rede baseia-se na análise da conectividade e do caminho dos dados:
*   **`ping`:** Verifica a alcançabilidade e a latência (ICMP).
*   **`traceroute`:** Identifica cada salto (router) entre a origem e o destino.
*   **`ip addr show`:** Exibe as interfaces e endereços IP locais.
*   **`dig`:** Consulta registros DNS.
*   **`nmap`:** Explora portas abertas e serviços ativos num host.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1cm,
    dhcpstep/.style={draw, rectangle, minimum width=3cm, minimum height=0.8cm, align=center, font=\sffamily\small},
    arrow/.style={-stealth, thick}
]
    \node (s1) [dhcpstep, fill=orange!10] {DHCP Discover \\ \tiny{Broadcast: "Preciso de IP"}};
    \node (s2) [dhcpstep, fill=orange!10, below=of s1] {DHCP Offer \\ \tiny{Server: "Toma o 192.168.1.50"}};
    \node (s3) [dhcpstep, fill=orange!10, below=of s2] {DHCP Request \\ \tiny{Client: "Aceito esse IP"}};
    \node (s4) [dhcpstep, fill=orange!10, below=of s3] {DHCP ACK \\ \tiny{Server: "Confirmado!"}};

    \draw [arrow] (s1) -- (s2);
    \draw [arrow] (s2) -- (s3);
    \draw [arrow] (s3) -- (s4);
\end{tikzpicture}
\end{center}
```

---

## Parte 5: Segurança e Tópicos Avançados

### Monitorização e Firewalls

O **Wireshark** permite a inspeção profunda de pacotes (*packet sniffing*), sendo a ferramenta definitiva para depuração de protocolos. Para a proteção, as **Firewalls** (como `iptables`, `nftables` ou o sistema `pfSense`) filtram o tráfego com base em regras de portas e IPs.

### SSH Avançado e Sincronização

O SSH permite funcionalidades além da shell:
*   **Túneis SSH:** Encaminham tráfego de portas remotas para o localhost.
*   **X11 Forwarding:** Permitem a execução de aplicações gráficas remotas no desktop local.
*   **`rsync`:** Otimiza a transferência de ficheiros enviando apenas as diferenças (*deltas*), operando de forma segura sobre SSH.

### Infraestrutura Web Moderna

Um **Proxy Reverso** (ex: NGINX) atua como a face pública de um servidor, distribuindo a carga entre múltiplas aplicações internas (Load Balancing) e aumentando a segurança. Para a encriptação, o **Let's Encrypt** automatiza a emissão de certificados SSL/TLS gratuitos, tornando o HTTPS o padrão universal da web.

---

## Recursos Adicionais

Para aprofundar os conceitos apresentados, recomendam-se os seguintes recursos:

*   **Análise de Tráfego:** [Wireshark](https://www.wireshark.org/) e [Nmap](https://nmap.org/).
*   **Segurança Web:** [Let's Encrypt](https://letsencrypt.org/).
*   **Documentação Técnica:** [Mozilla HTTP Overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview).
*   **Administração Linux:** Guias oficiais sobre o comando `ip` e a ferramenta `rsync`.
