# Servidores Web

## Introdução

Um servidor Web é um componente vital da infraestrutura da Internet moderna. Tecnicamente, pode ser definido como um sistema informático que processa pedidos através do protocolo HTTP (HyperText Transfer Protocol) ou da sua variante segura, o HTTPS. No entanto, é importante distinguir entre as duas aceções do termo: no sentido do hardware, refere-se à máquina física ou virtual que armazena os ficheiros; no sentido do software, refere-se à aplicação que interpreta os pedidos dos clientes (como browsers) e entrega o conteúdo solicitado.

A função primordial de um servidor Web é o armazenamento, processamento e entrega de recursos web aos utilizadores. Este processo baseia-se num modelo de comunicação cliente-servidor, onde o cliente inicia a interação solicitando um recurso específico (uma página HTML, uma imagem, um ficheiro CSS ou dados JSON) e o servidor responde com o conteúdo correspondente ou com uma mensagem indicando que a operação não foi possível.

### Breve História e Evolução da Web

A World Wide Web foi concebida por Tim Berners-Lee no CERN em 1989. O primeiro servidor web da história correu num computador NeXT e servia páginas puramente estáticas, compostas por texto e hiperligações simples. Naquela época, a web era uma ferramenta de partilha de documentos académicos e científicos.

Com a evolução tecnológica, os servidores web transformaram-se de simples distribuidores de ficheiros em sistemas extremamente complexos. Hoje em dia, são responsáveis por gerir a segurança das comunicações, distribuir o tráfego entre múltiplos servidores (equilíbrio de carga), realizar cache de conteúdos para melhorar a performance e servir como porta de entrada para aplicações complexas que interagem com bases de dados em tempo real.

## O Protocolo HTTP

O HTTP é um protocolo de camada de aplicação que constitui a base da troca de dados na Web. Uma das suas características fundamentais é ser um protocolo *stateless* (sem estado), o que significa que cada par de pedido-resposta é tratado de forma independente. O servidor não mantém memória de pedidos anteriores do mesmo cliente, a menos que sejam utilizados mecanismos adicionais, como cookies ou tokens de sessão.

Atualmente, a Web utiliza maioritariamente as versões HTTP/1.1 e HTTP/2. O HTTP/2 introduziu melhorias significativas na performance, permitindo o multiplexing (vários pedidos na mesma ligação TCP). O HTTP/3, a versão mais recente, baseia-se no protocolo QUIC e visa reduzir ainda mais a latência e melhorar a resiliência em redes móveis.

### Ciclo de Pedido e Resposta

O funcionamento da Web pode ser visualizado como um diálogo contínuo. Quando um utilizador introduz um URL no browser, este atua como cliente e envia uma mensagem de pedido estruturada ao servidor. Esta mensagem contém o método (o que fazer), o caminho do recurso (onde está) e os cabeçalhos (metadados).

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=4cm,
    box/.style={draw, rectangle, minimum width=3cm, minimum height=1.5cm, fill=blue!10, font=\sffamily\small, align=center},
    arrow/.style={-stealth, thick}
]
    \node (client) [box] {Cliente\\(Browser)};
    \node (server) [box, right=of client] {Servidor\\Web};

    \draw [arrow] ([yshift=0.4cm]client.east) -- ([yshift=0.4cm]server.west) node[midway, above, font=\tiny] {Pedido HTTP (GET /index.html)};
    \draw [arrow] ([yshift=-0.4cm]server.west) -- ([yshift=-0.4cm]client.east) node[midway, below, font=\tiny] {Resposta HTTP (200 OK + Conteúdo)};
    
    \node [below=0.2cm of client, font=\tiny] {IP de Origem};
    \node [below=0.2cm of server, font=\tiny] {IP de Destino (Porta 80/443)};
\end{tikzpicture}
\end{center}
```

### Métodos e Códigos de Estado

Os métodos HTTP definem a intenção do cliente. O método **GET** é o mais comum, utilizado para ler dados sem causar alterações no servidor. O **POST** é utilizado para enviar dados (como um formulário de login). O **PUT** e o **DELETE** são utilizados para atualizar e remover recursos, respetivamente, sendo fundamentais em arquiteturas de APIs modernas (REST).

As respostas do servidor são sempre acompanhadas por um código de estado numérico que indica o resultado da operação:
- **200 OK:** O pedido foi processado com sucesso.
- **301/302 Redirect:** O recurso mudou de localização.
- **404 Not Found:** O servidor não conseguiu encontrar o recurso solicitado.
- **500 Internal Server Error:** Ocorreu uma falha no código ou na configuração do servidor.

## Conteúdo Estático vs. Dinâmico

Uma das distinções mais importantes na arquitetura web é a diferença entre conteúdo estático e dinâmico. Esta distinção determina como o servidor processa o pedido e qual o impacto na escalabilidade do sistema.

### Conteúdo Estático

O conteúdo estático consiste em ficheiros armazenados no disco do servidor que são entregues ao cliente sem qualquer modificação. Ficheiros HTML, folhas de estilo CSS, scripts JavaScript e imagens são exemplos clássicos. Como o servidor apenas necessita de ler o ficheiro do disco e enviá-lo para a rede, este processo é extremamente eficiente. Estes ficheiros são ideais para serem armazenados em CDNs (*Content Delivery Networks*), aproximando os dados do utilizador final e reduzindo o tempo de latência.

### Conteúdo Dinâmico

O conteúdo dinâmico é gerado "on-the-fly" pelo servidor. Quando o servidor recebe um pedido para um recurso dinâmico, ele não lê um ficheiro pronto; em vez disso, executa um programa ou script (escrito em linguagens como Python, JavaScript/Node.js ou PHP). Este programa pode consultar uma base de dados para obter informações personalizadas, como o saldo de uma conta bancária ou o feed de uma rede social. Só após este processamento é que o servidor constrói a resposta final e a envia ao cliente.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.8cm,
    block/.style={draw, rectangle, minimum width=2.2cm, minimum height=0.8cm, fill=gray!10, font=\sffamily\tiny, align=center},
    server/.style={draw, rectangle, minimum width=6cm, minimum height=4.5cm, fill=blue!5, dashed, rounded corners=5pt},
    arrow/.style={-stealth, thick}
]
    \node (sbox) [server] {};
    \node [above=0.2cm of sbox, font=\sffamily\bfseries\small] {Arquitetura Interna do Servidor};

    \node (req) [left=1.2cm of sbox] {Pedido HTTP};
    \node (static) [block, fill=green!15] at (-1.2, 1.2) {Ficheiros no Disco\\(HTML/Imagens)};
    \node (app) [block, fill=orange!15] at (-1.2, 0) {Motor de Execução\\(Lógica da App)};
    \node (db) [block, fill=red!15] at (-1.2, -1.2) {Sistema de Base\\de Dados};
    \node (resp) [right=1.2cm of sbox] {Resposta};

    \draw [arrow] (req.east) -- ([xshift=0.3cm]req.east) |- (static.west);
    \draw [arrow] (req.east) -- ([xshift=0.3cm]req.east) |- (app.west);
    \draw [arrow] (static.east) -| ([xshift=-0.5cm]resp.west) -- (resp.west);
    \draw [arrow, <->] (app.south) -- (db.north);
    \draw [arrow] (app.east) -- (resp.west);
    
\end{tikzpicture}
\end{center}
```

## Arquiteturas de Servidores Web

A escolha do software de servidor web depende das necessidades de performance, flexibilidade e facilidade de configuração.

### Apache HTTP Server

O Apache é o servidor web mais antigo e estável ainda em uso generalizado. A sua grande força reside no sistema de módulos, que permite estender as suas funcionalidades para quase qualquer necessidade. No entanto, o Apache utiliza tradicionalmente um modelo baseado em processos, onde cada ligação pode consumir uma quantidade significativa de memória, o que o torna menos eficiente que os concorrentes modernos em situações de tráfego massivo.

### Nginx

O Nginx foi criado especificamente para resolver o problema de lidar com milhares de ligações simultâneas (o problema C10K). Ao contrário do Apache, o Nginx utiliza uma arquitetura orientada a eventos e não bloqueante. Um único processo do Nginx pode gerir milhares de pedidos de forma eficiente. Por esta razão, o Nginx é frequentemente utilizado não apenas como servidor web, mas também como proxy inverso e equilibrador de carga.

| Característica | **Apache** | **Nginx** |
| :--- | :--- | :--- |
| **Arquitetura** | Processos/Threads (Um por ligação) | **Eventos (Assíncrono)** |
| **Performance** | Boa, mas limitada pela RAM | **Excelente para tráfego massivo** |
| **Configuração** | `.htaccess` por diretório (Flexível) | Centralizada (Mais segura) |
| **Uso Ideal** | Alojamento partilhado, legacy | **APIs, Apps modernas, Reverse Proxy** |

## Proxy Inverso e Equilíbrio de Carga

Em sistemas de larga escala, o servidor web raramente está exposto diretamente à Internet. Em vez disso, utiliza-se um **Proxy Inverso**. Este servidor recebe os pedidos e encaminha-os para os servidores de aplicação internos.

Esta camada adicional oferece vantagens cruciais:
1. **Segurança:** O endereço IP real dos servidores de aplicação fica escondido.
2. **Terminação SSL:** O proxy trata da cifragem, aliviando os servidores de aplicação dessa carga.
3. **Equilíbrio de Carga (Load Balancing):** O proxy distribui os pedidos por vários servidores de forma equitativa, garantindo que nenhum fica sobrecarregado.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1.2cm,
    node/.style={draw, rectangle, minimum width=2.5cm, minimum height=0.8cm, fill=blue!10, font=\sffamily\tiny, align=center},
    proxy/.style={draw, rectangle, minimum width=2.5cm, minimum height=1.2cm, fill=orange!20, font=\sffamily\tiny, align=center},
    arrow/.style={-stealth, thick}
]
    \node (internet) [cloud, draw, minimum width=2cm, minimum height=1.2cm, fill=gray!5] {Internet};
    \node (lb) [proxy, right=2.5cm of internet] {Proxy Inverso /\\Load Balancer};
    
    \node (s2) [node, right=2.5cm of lb] {Servidor de App B};
    \node (s1) [node, above=of s2] {Servidor de App A};
    \node (s3) [node, below=of s2] {Servidor de App C};

    \draw [arrow] (internet.east) -- (lb.west) node[midway, above, font=\tiny] {Tráfego Externo};
    \draw [arrow] (lb.east) -- (s1.west);
    \draw [arrow] (lb.east) -- (s2.west);
    \draw [arrow] (lb.east) -- (s3.west);
    
    \node [below=0.1cm of lb, font=\tiny\itshape] {Distribuição de Tráfego};
\end{tikzpicture}
\end{center}
```

## Configuração de Sites Virtuais (Virtual Hosting)

Um único servidor físico pode alojar centenas de sites diferentes, otimizando recursos de hardware e facilitando a gestão. Esta funcionalidade é conhecida como **Virtual Hosting** e pode ser implementada de três formas principais:

1. **Baseado em Nome (Name-based):** É a forma mais comum. O servidor utiliza o cabeçalho `Host` do pedido HTTP/1.1 para determinar qual o site deve responder. Isto permite que múltiplos domínios (ex: `site1.pt` e `site2.pt`) partilhem o mesmo endereço IP.
2. **Baseado em IP:** Cada site tem o seu próprio endereço IP dedicado. O servidor escuta em múltiplos IPs e entrega o conteúdo correspondente ao IP onde o pedido foi recebido.
3. **Baseado em Porto:** Diferentes sites são servidos em diferentes portos TCP (ex: `exemplo.pt:80` e `exemplo.pt:8080`).

No contexto moderno, o Virtual Hosting baseado em nome é o padrão. Contudo, com a introdução do HTTPS, surgiu o desafio de saber qual o certificado SSL a apresentar antes de ler o cabeçalho HTTP. Este problema foi resolvido com a extensão **SNI (Server Name Indication)**, que permite ao browser indicar o nome do domínio durante o aperto de mão (*handshake*) do TLS.

## Segurança e HTTPS

A segurança das comunicações web baseia-se no protocolo HTTPS, que utiliza TLS (Transport Layer Security) para garantir a confidencialidade, integridade e autenticidade dos dados.

### O Processo de Cifragem
O HTTPS combina dois tipos de cifragem:
- **Cifragem Assimétrica (Chave Pública):** Utilizada durante o *handshake* inicial para trocar uma chave secreta de forma segura.
- **Cifragem Simétrica:** Uma vez estabelecida a chave secreta, esta é utilizada para cifrar todo o tráfego subsequente, por ser muito mais rápida computacionalmente.

### Certificados e Autoridades de Certificação
Para implementar HTTPS, o servidor necessita de um **Certificado SSL/TLS**. Este documento digital é emitido por uma Autoridade de Certificação (CA) e garante ao utilizador que o servidor pertence realmente a quem diz pertencer. O surgimento do **Let's Encrypt** permitiu a democratização da segurança web, oferecendo certificados gratuitos e ferramentas de renovação automática como o Certbot.

### Boas Práticas de Segurança
Além do HTTPS, a segurança de um servidor web envolve a configuração de cabeçalhos específicos, como o **HSTS (HTTP Strict Transport Security)**, que obriga o browser a usar sempre HTTPS, e a desativação de protocolos antigos e vulneráveis (como SSLv3 ou TLS 1.0/1.1), garantindo que apenas as suites de cifragem mais modernas e seguras são utilizadas.

## Recursos Adicionais

Para aprofundar os conhecimentos sobre a administração e funcionamento de servidores web, recomendam-se as seguintes fontes:

- **[Nginx Documentation](https://nginx.org/en/docs/):** A referência definitiva para a configuração e otimização do Nginx.
- **[Mozilla Developer Network (MDN) - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP):** Um guia detalhado sobre o protocolo HTTP, métodos e cabeçalhos.
- **[Apache HTTP Server Documentation](https://httpd.apache.org/docs/current/):** Guia completo para a gestão do servidor Apache.
- **[Let's Encrypt Documentation](https://letsencrypt.org/docs/):** Informação sobre como funciona a certificação SSL/TLS automática.
- **[W3Schools - HTTP Codes](https://www.w3schools.com/tags/ref_httpmessages.asp):** Uma lista de referência rápida para os códigos de estado HTTP.
