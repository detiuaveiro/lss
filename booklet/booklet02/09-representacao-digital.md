# Representação e Armazenamento de Informação Digital

## Introdução

A engenharia de sistemas modernos fundamenta-se na capacidade de capturar, representar e processar dados de forma eficiente. Desde a leitura de sensores em tempo real até a gestão de logs de auditoria em larga escala, a escolha da representação digital impacta diretamente a performance, a fiabilidade e a interoperabilidade de qualquer sistema.

É crucial distinguir entre **dados** e **informação**. Enquanto os dados são factos brutos, símbolos ou sinais desprovidos de contexto (ex: a sequência `[25, 26, 25, 24]`), a informação surge quando esses dados são processados e organizados para adquirir significado (ex: "A temperatura média da sala foi de 25°C"). Esta transição é frequentemente descrita pela **Pirâmide DIKW** (Dados, Informação, Conhecimento, Sabedoria), onde cada nível representa um aumento na abstração e na utilidade da informação.

```{=latex}
\begin{center}
\begin{tikzpicture}[scale=0.8, transform shape]
    % Pyramid levels
    \draw[thick, fill=blue!10] (0,0) -- (4,0) -- (2,4) -- cycle;
    \draw[thick, fill=blue!20] (1,0) -- (3,0) -- (2,2) -- cycle;
    \draw[thick, fill=blue!30] (1.5,0) -- (2.5,0) -- (2,1) -- cycle;
    \draw[thick, fill=blue!40] (1.75,0) -- (2.25,0) -- (2,0.5) -- cycle;

    % Labels
    \node at (2, -0.4) {\bfseries\sffamily Dados};
    \node at (2, 0.7) {\bfseries\sffamily Informação};
    \node at (2, 1.5) {\bfseries\sffamily Conhecimento};
    \node at (2, 2.5) {\bfseries\sffamily Sabedoria};

    % Annotations
    \node[anchor=west, font=\tiny\itshape] at (4.2, 0.2) {Sinais brutos, símbolos};
    \node[anchor=west, font=\tiny\itshape] at (4.2, 1.0) {Estrutura, contexto, significado};
    \node[anchor=west, font=\tiny\itshape] at (4.2, 1.8) {Sintetização, aplicação, "como"};
    \node[anchor=west, font=\tiny\itshape] at (4.2, 2.6) {Avaliação, "porquê", introspeção};
\end{tikzpicture}
\end{center}
```

---

## Parte 1: Representação Digital e Codificação

### Bits, Bytes e Endianness

No nível mais elementar, a informação digital é binária. O **bit** (0 ou 1) é a menor unidade, e o **byte** (conjunto de 8 bits) permite representar $2^8 = 256$ valores distintos. Para facilitar a leitura humana, utiliza-se a representação **hexadecimal** (base 16).

Um conceito crítico na comunicação entre sistemas é o **Endianness** (a ordem dos bytes na memória):
*   **Big-Endian:** O byte mais significativo é armazenado no endereço mais baixo. É o padrão utilizado no **Network Order** (comunicação de rede).
*   **Little-Endian:** O byte menos significativo é armazenado primeiro. É comum em arquiteturas x86 (Intel/AMD).

### Codificação de Caracteres: De ASCII a UTF-8

A representação de texto evoluiu para resolver a fragmentação linguística:
1.  **ASCII:** Padrão original de 7 bits, limitado ao alfabeto inglês e símbolos básicos.
2.  **Unicode:** Um padrão universal que atribui um *code point* único a cada caracter de cada língua do mundo.
3.  **UTF-8:** A codificação dominante na web. É de **comprimento variável** (1 a 4 bytes), sendo retrocompatível com ASCII. Isto significa que o texto em inglês permanece eficiente (1 byte/char), enquanto caracteres complexos ou emojis utilizam mais bytes.

---

## Parte 2: Hierarquia e Estrutura de Dados

Os dados são classificados de acordo com o seu grau de organização, o que determina as ferramentas necessárias para o seu processamento.

### O Espectro da Estrutura

1.  **Dados Não Estruturados:** Não possuem um formato predefinido. Exemplos incluem ficheiros de texto livre, binários, imagens e áudio.
2.  **Dados Semi-Estruturados:** Possuem marcadores ou *tags* que definem a hierarquia, mas não seguem um esquema rígido. Exemplos: JSON, XML, YAML.
3.  **Dados Estruturados:** Seguem um modelo estrito, geralmente tabular (linhas e colunas). Exemplo: Bases de Dados Relacionais (SQL), ficheiros CSV.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=0.5cm,
    box/.style={draw, rectangle, minimum width=3cm, minimum height=1cm, align=center, font=\sffamily\small},
    arrow/.style={-stealth, thick}
]
    % Levels
    \node (unstruct) [box, fill=red!10] {Não Estruturados \\ \tiny{Texto, Imagem, Binário}};
    \node (semi) [box, fill=yellow!10, below=of unstruct] {Semi-Estruturados \\ \tiny{JSON, XML, YAML}};
    \node (struct) [box, fill=green!10, below=of semi] {Estruturados \\ \tiny{Tabelas, CSV, SQL}};

    % Arrows
    \draw [arrow] (unstruct) -- (semi) node[midway, right, font=\tiny] {Adição de tags/esquema};
    \draw [arrow] (semi) -- (struct) node[midway, right, font=\tiny] {Rigidez total do esquema};
    
    \node [left=0.5cm of unstruct, rotate=90, anchor=south, font=\sffamily\bfseries\small] {Flexibilidade};
    \node [left=0.5cm of struct, rotate=90, anchor=south, font=\sffamily\bfseries\small] {Rigidez};
\end{tikzpicture}
\end{center}
```

---

## Parte 3: Processamento de Dados Não Estruturados

### Ficheiros de Texto vs. Binários

A distinção fundamental reside na legibilidade. Ficheiros de texto são sequências de caracteres (UTF-8), enquanto ficheiros binários são sequências de bytes otimizadas para máquinas. Para identificar binários, utilizam-se os **Magic Numbers** — os primeiros bytes do ficheiro que funcionam como uma assinatura (ex: `0x89 0x50 0x4E 0x47` para ficheiros PNG).

### Ferramentas de Manipulação de Texto

No ecossistema Unix, o processamento de texto é feito através de fluxos (*pipelines*):
*   **`grep`:** Filtra linhas com base em **Expressões Regulares (Regex)**.
*   **`awk`:** Processa dados organizados em colunas.
*   **`sed`:** Realiza substituições e transformações de texto em tempo real.

As **Regex** permitem descrever padrões complexos (ex: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$` para validar emails), sendo essenciais para a análise de logs de sistema.

---

## Parte 4: Dados Semi-Estruturados e Serialização

### Formatos de Troca de Dados

*   **CSV (Comma Separated Values):** Simples e universal para dados tabulares, mas falha ao representar hierarquias ou tipos de dados complexos.
*   **XML:** Robusto e suporta esquemas complexos (XSD), mas é excessivamente verboso.
*   **JSON:** O padrão para APIs modernas. É leve, suporta aninhamento e é nativamente compatível com estruturas de dados (Listas e Dicionários) em linguagens como Python.
*   **YAML:** Focado na legibilidade humana e indentação, sendo o padrão para ficheiros de configuração (Docker, Kubernetes).

### Serialização Binária e Performance

Quando a legibilidade humana é secundária ao desempenho (ex: comunicação entre microsserviços), utiliza-se a serialização binária:
*   **BSON / MessagePack:** Versões binárias do JSON que reduzem o tamanho do payload.
*   **Protocol Buffers (Protobuf):** Desenvolvido pela Google, exige a definição prévia de um esquema (`.proto`). O resultado é um formato binário extremamente compacto e rápido de processar.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1cm,
    block/.style={draw, rectangle, minimum width=2.5cm, minimum height=1cm, align=center, font=\sffamily\small},
    arrow/.style={-stealth, thick}
]
    % Flow
    \node (obj) [block, fill=blue!10] {Objeto na Memória \\ \tiny{Python Dict / Class}};
    \node (serial) [block, fill=green!10, right=of obj] {Serializador \\ \tiny{JSON / Protobuf}};
    \node (wire) [block, fill=red!10, right=of serial] {Formato de Transporte \\ \tiny{Bytes / Wire Format}};

    \draw [arrow] (obj) -- (serial) node[midway, above, font=\tiny] {Serializar};
    \draw [arrow] (serial) -- (wire) node[midway, above, font=\tiny] {Transmitir};
    \draw [arrow] (wire.south) -- ++(0,-0.5) -- ++(-6,0) -- (obj.south) node[midway, below, font=\tiny] {Desserializar};
\end{tikzpicture}
\end{center}
```

---

## Parte 5: Ferramentas de Validação e Manipulação

### Processamento via Linha de Comando

Para manipular JSON e YAML sem escrever scripts, utilizam-se as ferramentas `jq` e `yq`. Estas permitem filtrar, transformar e extrair valores de ficheiros de configuração complexos diretamente no terminal.

### Validação com Pydantic

Em Python, a validação de dados é efetuada de forma robusta através da biblioteca **Pydantic**. Ao definir modelos baseados em tipos (*type hints*), o Pydantic garante que os dados recebidos de uma API ou ficheiro cumprem as regras de negócio (ex: validar se um campo é um email válido ou um número inteiro positivo), convertendo tipos automaticamente quando possível.

---


## Comparativo de Formatos de Serialização

A escolha do formato de troca de dados impacta a latência e a manutenibilidade do sistema:

| Formato | Legibilidade | Esquema | Tamanho | Performance | Caso de Uso Ideal |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **CSV** | Média | Não | Pequeno | Alta | Exportação de tabelas simples |
| **JSON** | Alta | Opcional | Médio | Média | APIs Web, Configurações |
| **YAML** | Muito Alta | Opcional | Médio | Média | Configurações (K8s, Docker) |
| **Protobuf** | Nula | Obrigatório | Muito Pequeno | Muito Alta | Microsserviços (gRPC) |

---

## Recursos Adicionais


*   **Regular Expressions:** [Regex101](https://regex101.com/) (Ferramenta de teste e validação de padrões).
*   **JSON Validation:** [JSON Schema](https://jsonschema.net/).
*   **Binary Serialization:** [Google Protocol Buffers](https://developers.google.com/protocol-buffers).
*   **Python Data Validation:** [Pydantic Documentation](https://docs.pydantic.dev/).
