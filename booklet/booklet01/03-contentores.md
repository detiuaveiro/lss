# Contentores e Orquestração

## Introdução

No desenvolvimento de *software* moderno, garantir a paridade entre ambientes (desenvolvimento, teste e produção) é um dos maiores desafios. O problema clássico "na minha máquina funciona" é mitigado pela tecnologia de **Contentores**.

Um contentor é uma unidade de *software* padrão que empacota o código de uma aplicação e todas as suas dependências, permitindo que esta seja executada de forma rápida e fiável em qualquer ambiente computacional.

### Comparação: VMs vs. Contentores

Enquanto as Máquinas Virtuais (VMs) virtualizam o hardware, os contentores virtualizam o Sistema Operativo.

- **VMs:** Cada VM inclui uma cópia completa de um SO convidado, os binários/bibliotecas necessários e a aplicação. Isto consome gigabytes de espaço e minutos a arrancar.
- **Contentores:** Partilham o *kernel* do SO anfitrião. São extremamente leves (megabytes) e arrancam em segundos.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    layer/.style={draw, rectangle, minimum width=4cm, minimum height=0.6cm, rounded corners=1pt, font=\sffamily\tiny, align=center},
    hw/.style={fill=gray!30},
    kernel/.style={fill=blue!30},
    guest/.style={fill=green!20},
    app/.style={fill=orange!20},
    engine/.style={fill=red!20}
]
    % VM View
    \node (hw1) [layer, hw] {Hardware Físico};
    \node (hyp1) [layer, kernel, above=of hw1] {Hipervisor};
    \node (gos1) [layer, guest, above left=0.8cm and -2cm of hyp1, minimum width=1.8cm] {SO Convidado};
    \node (app1) [layer, app, above=0.1cm of gos1, minimum width=1.8cm] {Aplicação A};
    \node (gos2) [layer, guest, above right=0.8cm and -2cm of hyp1, minimum width=1.8cm] {SO Convidado};
    \node (app2) [layer, app, above=0.1cm of gos2, minimum width=1.8cm] {Aplicação B};
    \node at ($(hw1.south)-(0,0.5)$) {\textbf{Máquinas Virtuais}};

    % Container View
    \begin{scope}[xshift=6cm]
        \node (hw2) [layer, hw] {Hardware Físico};
        \node (ker2) [layer, kernel, above=of hw2] {SO Anfitrião (Kernel)};
        \node (eng2) [layer, engine, above=of ker2] {Motor de Contentores};
        \node (app3) [layer, app, above left=0.8cm and -2cm of eng2, minimum width=1.8cm] {Aplicação A};
        \node (app4) [layer, app, above right=0.8cm and -2cm of eng2, minimum width=1.8cm] {Aplicação B};
        \node at ($(hw2.south)-(0,0.5)$) {\textbf{Contentores}};
    \end{scope}
\end{tikzpicture}
\end{center}
```

## Fundamentos do Isolamento: Namespaces e Cgroups

Um contentor é, na sua essência, um processo normal no Linux ao qual foram aplicadas restrições de visibilidade e de recursos.

1.  **Namespaces (O que o processo vê):** Virtualizam os recursos do sistema.
    - **PID:** O processo vê-se como o PID 1.
    - **NET:** Interface de rede privada.
    - **MNT:** Sistema de ficheiros isolado.
2.  **Cgroups (O que o processo consome):** Limitam o uso de hardware.
    - Limites de CPU (ex: 0.5 cores).
    - Limites de Memória (ex: 256MB).

## Imagens e o Sistema de Ficheiros em Camadas

As imagens de contentores utilizam um **Union File System (UnionFS)**. Uma imagem é composta por várias camadas apenas de leitura (*read-only*). Quando iniciamos um contentor, é adicionada uma camada fina de escrita (*writable layer*) no topo.

### Copy-on-Write (CoW)
Se a aplicação precisar de modificar um ficheiro que pertence a uma camada inferior, o Docker copia esse ficheiro para a camada de escrita antes de aplicar a alteração. Isto permite que múltiplos contentores partilhem as mesmas camadas de imagem base, poupando imenso espaço em disco.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    layer/.style={draw, rectangle, minimum width=6cm, minimum height=0.7cm, font=\sffamily\small, align=center},
    ro/.style={fill=blue!10},
    rw/.style={fill=green!20}
]
    \node (rw) [layer, rw] {Camada de Escrita (Container Layer) - Read/Write};
    \node (l3) [layer, ro, below=0pt of rw] {Camada 3: Instalação do Nginx - Read-Only};
    \node (l2) [layer, ro, below=0pt of l3] {Camada 2: Configuração de Rede - Read-Only};
    \node (l1) [layer, ro, below=0pt of l2] {Camada 1: Imagem Base Debian - Read-Only};

    \draw [decorate, decoration={brace, amplitude=10pt}] ($(l1.south west)-(0.5,0)$) -- ($(l3.north west)-(0.5,0)$) node [midway, left=15pt, rotate=90, anchor=south] {Imagem};
\end{tikzpicture}
\end{center}
```

## Rede de Contentores

O Docker oferece vários controladores de rede (*drivers*):

1.  **Bridge (Padrão):** Cria uma rede virtual interna. Os contentores comunicam entre si via IP privado ou nomes de serviço. O acesso externo é feito via **Port Mapping** (ex: `-p 8080:80`).
2.  **Host:** O contentor partilha a pilha de rede do anfitrião diretamente. Sem isolamento, mas com desempenho máximo.
3.  **None:** O contentor não tem rede externa.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    comp/.style={draw, rectangle, minimum width=2.5cm, minimum height=1.5cm, fill=blue!10, font=\sffamily\tiny, align=center},
    net/.style={draw, ellipse, minimum width=2.5cm, fill=gray!20, font=\sffamily\tiny, align=center}
]
    \node (host) [comp] {Anfitrião\\(IP: 192.168.1.10)};
    \node (cont) [comp, above=2cm of host, fill=green!10] {Contentor\\(Porta Interna: 80)};
    \node (internet) [net, right=3cm of host] {Internet};

    \draw [thick, <->] (host.east) -- (internet.west);
    \draw [thick, <->, orange] (host.north) -- (cont.south) node[midway, right, align=center] {Mapping\\Porta 8080 -> 80};
\end{tikzpicture}
\end{center}
```

## Dockerfile Avançado

Um `Dockerfile` bem construído deve ser eficiente e seguro.

```dockerfile
# Argumentos de build
ARG VERSION=3.19
FROM alpine:${VERSION}

# Metadados
LABEL maintainer="mario.antunes@ua.pt"

# Instalação com limpeza de cache para reduzir tamanho
RUN apk add --no-cache python3 py3-pip && \
    rm -rf /var/cache/apk/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Verificação de saúde (Healthcheck)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080
USER guest
CMD ["python3", "app.py"]
```

## Orquestração com Docker Compose

O Compose permite gerir pilhas complexas com redes e volumes persistentes.

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_URL=postgres://user:password@db:5432/mydb
    env_file:
      - .env
    depends_on:
      - db
    networks:
      - frontend
      - backend

  db:
    image: postgres:16-alpine
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - backend

networks:
  frontend:
  backend:
    internal: true

volumes:
  db_data:
```

## Recursos Adicionais

- **[Docker Documentation](https://docs.docker.com/):** O manual oficial.
- **[Open Container Initiative (OCI)](https://opencontainers.org/):** Especificações padrão para imagens e runtimes.
- **[Project Atomic (Cgroups)](https://projectatomic.io/docs/cgroups/):** Guia detalhado sobre gestão de recursos.
- **[Docker Networking Deep Dive](https://runnable.com/blog/docker-networking-explained):** Explicação detalhada dos drivers de rede.
