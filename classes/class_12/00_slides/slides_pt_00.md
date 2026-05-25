---
title: Bases de Dados Relacionais e SQL II
---

# Panorama SQL e NoSQL

## A Evolução das Bases de Dados

O mundo das bases de dados mudou de tabelas rígidas para um ecossistema diverso.

* **Anos 70-80:** RDBMS (Oracle, IBM) - Foco na eficiência de armazenamento.
* **Anos 90:** BDs Orientadas a Objetos - Breve tentativa de alinhar código e dados.
* **Anos 2000:** A Explosão do Big Data - Google/Amazon precisavam de escala massiva.
* **Anos 2010:** Revolução NoSQL - Foco em disponibilidade e esquemas flexíveis.
* **Presente:** Persistência Poliglota - Usar a ferramenta certa para a tarefa certa.

## Relacional vs. Não-Relacional

* **Relacional (SQL):**
  * Esquema predeterminado (tabelas/linhas/colunas).
  * Consistência forte (ACID).
  * Ideal para dados estruturados e relações complexas.
* **Não-Relacional (NoSQL):**
  * Esquema dinâmico (documentos, pares, grafos).
  * Alta performance e escalonamento horizontal fácil.
  * Ideal para desenvolvimento rápido e conjuntos de dados massivos.

## Escalonamento Vertical vs. Horizontal

\begin{center}
\begin{tikzpicture}[scale=0.8, every node/.style={transform shape}]
    % Vertical Scaling
    \draw[fill=blue!10] (0,0) rectangle (1.5,1) node[midway, font=\tiny] {S1};
    \draw[->, thick] (0.75, 1.2) -- (0.75, 2.8) node[midway, right] {Scale Up};
    \draw[fill=blue!30] (0,3) rectangle (2,5) node[midway] {S1+};
    \node[below] at (0.75, 0) {\textbf{Vertical}};

    % Horizontal Scaling
    \begin{scope}[shift={(5,0)}]
        \draw[fill=green!10] (0,0) rectangle (1.2,0.8) node[midway, font=\tiny] {Node 1};
        \draw[->, thick] (1.5, 0.4) -- (3, 0.4) node[midway, above] {Scale Out};
        \draw[fill=green!20] (3.5,0) rectangle (4.7,0.8) node[midway, font=\tiny] {N1};
        \draw[fill=green!20] (5,0) rectangle (6.2,0.8) node[midway, font=\tiny] {N2};
        \draw[fill=green!20] (3.5,1) rectangle (4.7,1.8) node[midway, font=\tiny] {N3};
        \draw[fill=green!20] (5,1) rectangle (6.2,1.8) node[midway, font=\tiny] {N4};
        \node[below] at (3.1, 0) {\textbf{Horizontal}};
    \end{scope}
\end{tikzpicture}
\end{center}

## ACID vs. BASE

* **ACID (Padrão SQL):**
  * Atomicidade, Consistência, Isolamento, Durabilidade.
  * Os dados estão sempre precisos e atualizados para todos os clientes.
* **BASE (Padrão NoSQL):**
  * **B**asicamente **A**vailable (O sistema responde mesmo se nós falharem).
  * **S**oft State (Os dados podem mudar sem input devido a regras de consistência).
  * **E**ventual Consistency (Os dados serão consistentes... eventualmente).

# Teorema CAP

## Teorema CAP: Consistência

Consistência significa que todos os clientes veem os mesmos dados ao mesmo tempo, independentemente do nó a que se liguem.

* Para que isto aconteça, sempre que os dados são escritos num nó, devem ser replicados instantaneamente para todos os outros nós.
* Se ocorrer uma partição na rede, o sistema deve parar de aceitar escritas para garantir a consistência.

## Teorema CAP: Disponibilidade

Disponibilidade significa que qualquer cliente que faça um pedido de dados recebe uma resposta, mesmo que um ou mais nós estejam em baixo.

* Num sistema distribuído, isto é alcançado através de redundância.
* No entanto, se os nós não conseguirem comunicar (partição), podem devolver dados diferentes (antigos) para garantir que respondem sempre.

## Teorema CAP: Tolerância à Partição

Tolerância à Partição significa que o sistema continua a operar apesar de um número arbitrário de mensagens serem perdidas (ou atrasadas) pela rede entre os nós.

* Nos sistemas distribuídos modernos, a **Tolerância à Partição não é negociável**. Falhas de rede acontecem.
* Portanto, os sistemas devem escolher entre **Consistência (CP)** ou **Disponibilidade (AP)** durante uma partição.

## O Triângulo CAP

\begin{center}
\begin{tikzpicture}[scale=1.1, every node/.style={transform shape}]
    \draw[thick] (0,0) -- (4,0) -- (2,3.46) -- cycle;
    \node[below=8pt] at (0,0) {\textbf{Consistência (C)}};
    \node[below=8pt] at (4,0) {\textbf{Disponibilidade (A)}};
    \node[above=8pt] at (2,3.46) {\textbf{Tolerância Partição (P)}};
    
    \node[rotate=60, font=\tiny] at (0.6, 1.8) {CP (Postgres, MongoDB)};
    \node[rotate=-60, font=\tiny] at (3.4, 1.8) {AP (Cassandra, CouchDB)};
    \node[font=\tiny] at (2, 0.3) {CA (RDBMS Padrão)};
    
    \draw[fill=red, opacity=0.1] (2, 1.3) circle (0.6);
    \node at (2, 1.3) {\small Escolha 2};
\end{tikzpicture}
\end{center}

# Famílias NoSQL

## As Quatro Famílias NoSQL

Para lidar com diferentes estruturas de dados e necessidades de escala, surgiram quatro famílias principais:

* **Key-Value Stores:** Simples, rápidas, dados opacos.
* **Document Stores:** Flexíveis, hierárquicas, dados semi-estruturados.
* **Wide-Column Stores:** Otimizadas para dados esparsos e de alto volume.
* **Graph Databases:** Otimizadas para relações complexas e travessias.

## Key-Value Stores

O modelo NoSQL mais simples. Os dados são armazenados como um valor opaco indexado por uma chave única.

* **Analogia:** Um Dicionário Python ou um HashMap Java.
* **Pontos Fortes:** Extremamente rápido, ótimo para dados simples.
* **Uso:** Gestão de sessões, preferências de utilizador, tabelas de classificação em tempo real.
* **Exemplo:** **Redis**, Amazon DynamoDB.

## Exemplo de Uso Redis

```bash
# Operações básicas
SET user:101 "Alice"
GET user:101           # Output: "Alice"

# Incrementos atómicos
SET counter 10
INCR counter           # Output: 11

# Listas
LPUSH tasks "Email"
LPUSH tasks "Code"
RPOP tasks             # Output: "Email"
```

## Document Stores

Armazena dados em formato JSON, BSON ou XML. Os documentos são auto-descritivos.

* **Analogia:** Uma pasta de ficheiros JSON.
* **Pontos Fortes:** Esquema flexível (campos diferentes por documento), intuitivo para programadores.
* **Uso:** Gestão de conteúdos, catálogos de e-commerce, perfis de utilizador.
* **Exemplo:** **MongoDB**, CouchDB.

## Exemplo de Uso MongoDB

```javascript
// Inserir um documento
db.users.insertOne({
  name: "Alice",
  age: 25,
  skills: ["SQL", "Python"]
});

// Consultar com filtros flexíveis
db.users.find({ age: { $gt: 20 } });

// Atualizar campos específicos
db.users.updateOne(
  { name: "Alice" },
  { $set: { age: 26 } }
);
```

## Wide-Column Stores

Armazena dados em famílias de colunas em vez de linhas. Otimizado para escala horizontal massiva.

* **Analogia:** Um mapa 2D onde cada linha pode ter um conjunto diferente de colunas.
* **Pontos Fortes:** Elevada taxa de escrita, lida com petabytes de dados.
* **Uso:** Dados de séries temporais, logs históricos, análises em larga escala.
* **Exemplo:** **Apache Cassandra**, Google Bigtable.

## Graph Databases

Foca-se nas relações entre entidades. Os dados são representados como Nós e Arestas.

* **Analogia:** Uma rede social ou um mapa de rotas aéreas.
* **Pontos Fortes:** Consultas em relações complexas são muito mais rápidas que SQL Joins.
* **Uso:** Motores de recomendação, deteção de fraude, redes sociais.
* **Exemplo:** **Neo4j**, Amazon Neptune.

## Visualizando uma BD de Grafos

\begin{center}
\begin{tikzpicture}[node distance=2.5cm, every node/.style={transform shape}]
    \node[circle, draw, fill=blue!10] (alice) {Alice};
    \node[circle, draw, fill=blue!10, right=of alice] (bob) {Bob};
    \node[circle, draw, fill=blue!10, below=of alice] (sql) {Curso SQL};
    
    \draw[->, thick] (alice) -- (bob) node[midway, above] {AMIGO};
    \draw[->, thick] (alice) -- (sql) node[midway, left] {INSCRITO};
    \draw[->, thick] (bob) -- (sql) node[midway, right] {INSCRITO};
    \draw[->, thick, loop left] (sql) to node {PRÉ-REQUISITO} (sql);
\end{tikzpicture}
\end{center}

# Bases de Dados SQL Autónomas

## SQL Portátil: SQLite I

O SQLite é uma biblioteca em linguagem C que implementa um motor de base de dados SQL pequeno, rápido, autónomo, de alta fiabilidade e completo.

* **Embarcado:** Não é um processo separado. Faz parte da aplicação.
* **Configuração Zero:** Sem necessidade de configuração ou administração.
* **Atómico:** Transações totalmente compatíveis com ACID, mesmo após falhas.
* **Multiplataforma:** O formato do ficheiro da base de dados é estável e portátil.

## SQL Portátil: SQLite II

* **Arquitetura:**
  * Usa **B-Trees** para armazenamento de dados em disco.
  * Implementa **WAL (Write-Ahead Log)** para melhor concorrência.
* **Quando usar:**
  * Armazenamento local para apps móveis/desktop.
  * Dados intermédios durante análises.
  * Websites de tráfego baixo a médio.
* **Quando evitar:**
  * Ambientes com alta concorrência de escrita.
  * Aplicações distribuídas em múltiplos servidores.

## SQL In-Memory: H2 Database

O H2 é uma base de dados relacional baseada em Java que pode ser usada em modo embarcado ou servidor.

* **Performance:** Extremamente rápido porque pode correr inteiramente em RAM.
* **Padrão:** Suporta SQL standard e JDBC.
* **Compatibilidade:** Pode emular o comportamento de PostgreSQL, MariaDB ou Oracle.
* **Uso:** Testes unitários, prototipagem rápida e camadas de cache em aplicações Java.

# SQL Avançado: Performance

## O Problema da Procura

Imagine uma tabela `Alunos` com 1.000.000 de registos. Como é que o RDBMS encontra `nome = 'Alice'`?

* **Full Table Scan ($O(N)$):**
  * O motor lê todas as linhas, da primeira à última.
  * Se o registo estiver no fim, demora 1.000.000 de operações.
* **Index Scan ($O(\log N)$):**
  * Usando uma estrutura de dados ordenada (B-Tree).
  * Para 1.000.000 de registos, demora apenas $\sim 20$ operações.

## Visualização de B-Tree

\begin{center}
\begin{tikzpicture}[
    scale=0.8, every node/.style={transform shape},
    level distance=1.2cm,
    level 1/.style={sibling distance=5cm},
    level 2/.style={sibling distance=2cm},
    every node/.style={draw, rectangle, fill=blue!5, minimum height=0.6cm}
]
\node {\textbf{50}}
    child { node {\textbf{25, 40}}
        child { node {10, 20} }
        child { node {30, 35} }
        child { node {42, 48} }
    }
    child { node {\textbf{70, 90}}
        child { node {60, 65} }
        child { node {80, 85} }
        child { node {95, 99} }
    };
\end{tikzpicture}
\end{center}

A procura começa na raiz e segue os ponteiros com base nos intervalos de chaves, reduzindo drasticamente o número de comparações.

## Gestão de Índices

```sql
-- Criar um índice padrão
CREATE INDEX idx_user_email ON users(email);

-- Índice composto (A ordem importa!)
CREATE INDEX idx_name_age ON users(last_name, first_name);

-- Índice único (Reforça lógica de negócio)
CREATE UNIQUE INDEX idx_student_id ON students(id_number);

-- Remover um índice
DROP INDEX idx_user_email;
```

## O Trade-off

Os índices não são "gratuitos". Têm um custo:

* **Penalização de Escrita:** Cada vez que faz `INSERT`, `UPDATE` ou `DELETE`, o RDBMS também deve atualizar a estrutura do índice.
* **Espaço em Disco:** Os índices ocupam espaço significativo (por vezes tanto como os dados).
* **Manutenção:** Com o tempo, os índices podem tornar-se fragmentados e exigir reconstrução (`REINDEX` ou `VACUUM`).

## Planos de Execução

Como saber se o seu índice está realmente a ser usado?

```sql
-- SQLite
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = 'a@b.com';
-- Output: SEARCH TABLE users USING INDEX idx_user_email (email=?)

-- PostgreSQL / MySQL
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'a@b.com';
```

* **Seq Scan:** Scan completo da tabela (Mau para tabelas grandes).
* **Index Scan:** Usando eficientemente o índice (Bom).

# SQL Avançado: Analítica

## Window Functions: Conceito

As Window Functions realizam um cálculo através de um conjunto de linhas da tabela que estão de alguma forma relacionadas com a linha atual.

* **Diferença Chave:** Ao contrário de `GROUP BY`, as linhas não são colapsadas. Cada linha preserva a sua identidade original.
* **Estrutura:** `FUNCTION() OVER (PARTITION BY ... ORDER BY ...)`
* **Funções:** `SUM()`, `AVG()`, `RANK()`, `ROW_NUMBER()`, `LEAD()`, `LAG()`.

## Visualizando Window Functions

\begin{center}
\begin{tikzpicture}[scale=0.8, every node/.style={transform shape}]
    % Group By
    \draw[fill=gray!10] (0,0) rectangle (2,3) node[midway] {Dados Brutos};
    \draw[->, thick] (2.2, 1.5) -- (3.8, 1.5) node[midway, above] {GROUP BY};
    \draw[fill=blue!20] (4,1) rectangle (6,2) node[midway] {Colapsados};

    % Window Function
    \begin{scope}[shift={(0,-4)}]
        \draw[fill=gray!10] (0,0) rectangle (2,3) node[midway] {Dados Brutos};
        \draw[->, thick] (2.2, 1.5) -- (3.8, 1.5) node[midway, above] {OVER()};
        \draw[fill=gray!10] (4,0) rectangle (5.5,3) node[midway] {Brutos};
        \draw[fill=green!20] (5.5,0) rectangle (7.5,3) node[midway, font=\tiny] {Agregados};
    \end{scope}
\end{tikzpicture}
\end{center}

## Exemplos de Window Functions

```sql
-- Calcular um total acumulado
SELECT date, amount,
       SUM(amount) OVER (ORDER BY date) as total_acumulado
FROM sales;

-- Rankear itens dentro de uma categoria
SELECT name, category, price,
       RANK() OVER (PARTITION BY category ORDER BY price DESC) as pos
FROM products;

-- Lag/Lead (Aceder à linha anterior/seguinte)
SELECT date, amount,
       LAG(amount) OVER (ORDER BY date) as valor_dia_anterior
FROM sales;
```

## Common Table Expressions (CTE)

Uma CTE fornece uma forma de definir um conjunto de resultados temporário que pode referenciar dentro de uma única consulta.

* **Sintaxe:** `WITH nome_cte AS ( SELECT ... ) SELECT ... FROM nome_cte;`
* **Benefícios:**
  * **Legibilidade:** Divide consultas complexas em passos lógicos.
  * **Consultas Recursivas:** Permite consultar árvores ou dados hierárquicos.
  * **Modular:** Pode definir múltiplas CTEs numa única consulta.

## Exemplo de CTE

```sql
WITH MediaDepto AS (
    SELECT dept_id, AVG(salary) as sal_medio
    FROM employees
    GROUP BY dept_id
)
SELECT e.name, e.salary, d.sal_medio
FROM employees e
JOIN MediaDepto d ON e.dept_id = d.dept_id
WHERE e.salary > d.sal_medio;
```

* Aqui, calculamos primeiro as médias e depois usamos essa "tabela virtual" na consulta principal.

## CTEs Recursivas

As CTEs recursivas são usadas para percorrer estruturas hierárquicas (como um organigrama).

```sql
WITH RECURSIVE subordinados AS (
    -- Inicial: Selecionar o CEO
    SELECT id, name, manager_id FROM employees WHERE name = 'CEO'
    UNION ALL
    -- Recursivo: Juntar com subordinados
    SELECT e.id, e.name, e.manager_id
    FROM employees e
    INNER JOIN subordinados s ON s.id = e.manager_id
)
SELECT * FROM subordinados;
```

# Segurança de Bases de Dados

## SQL Injection: O Ataque

A vulnerabilidade de base de dados mais comum. Ocorre quando o input do utilizador é concatenado numa string de consulta.

```python
# CÓDIGO VULNERÁVEL
username = input("Insira nome: ") # Input: ' OR '1'='1
query = "SELECT * FROM users WHERE name = '" + username + "';"
# SQL resultante: SELECT * FROM users WHERE name = '' OR '1'='1';
```

* O atacante ignora a lógica e pode extrair, modificar ou apagar quaisquer dados.

## Prepared Statements: O Escudo

Os Prepared Statements (ou Consultas Parametrizadas) garantem que o RDBMS trata o input do utilizador estritamente como dados, nunca como código.

```python
# CÓDIGO SEGURO
username = input("Insira nome: ")
# 1. O template é enviado para a BD
# 2. Os dados são enviados separadamente como parâmetros
cursor.execute("SELECT * FROM users WHERE name = ?", (username,))
```

* **Fluxo de Trabalho:**
  1. **Prepare:** A BD analisa, compila e otimiza o plano da consulta.
  2. **Execute:** A BD vincula os valores ao plano e executa-o.

## Prepared Statements: Eficiência

Além da segurança, os prepared statements oferecem benefícios de performance:

* **Protocolo Binário:** Os dados são enviados num formato binário nativo, reduzindo o overhead.
* **Reutilização de Plano:** O RDBMS não precisa de re-analisar a consulta de cada vez.
* **Segurança:** Trata automaticamente o escape de caracteres e tipos de dados.

# Arquiteturas Modernas

## Persistência Poliglota

As aplicações modernas raramente usam apenas uma base de dados. Usam a melhor ferramenta para cada subproblema.

* **Encomendas (SQL):** Precisam de ACID para transações financeiras.
* **Catálogo de Produtos (NoSQL Documento):** Precisa de esquema flexível.
* **Procura de Produtos (Elasticsearch/Vector DB):** Precisa de procura de texto completo.
* **Sessão/Cache (Redis):** Precisa de latência inferior a milissegundos.
* **Ligações Sociais (Grafo):** Precisa de encontrar "Amigos de Amigos".

## A Modern Data Stack

\begin{center}
\begin{tikzpicture}[node distance=1.5cm, every node/.style={transform shape, font=\tiny}]
    \node[draw, rectangle, fill=blue!10, minimum width=2cm] (app) {App Móvel/Web};
    \node[draw, rectangle, fill=green!10, below left=of app] (pg) {PostgreSQL (Core)};
    \node[draw, rectangle, fill=red!10, below right=of app] (red) {Redis (Cache)};
    \node[draw, rectangle, fill=orange!10, below=of pg] (es) {Elasticsearch (Busca)};
    \node[draw, rectangle, fill=purple!10, below=of red] (mon) {MongoDB (Conteúdo)};
    
    \draw[->] (app) -- (pg);
    \draw[->] (app) -- (red);
    \draw[->] (app) -- (es);
    \draw[->] (app) -- (mon);
\end{tikzpicture}
\end{center}

# Resumo

## Lições Finais

* **Mudança de Paradigma:** SQL para estrutura e integridade; NoSQL para escala e flexibilidade.
* **Autónomas:** SQLite e H2 são ferramentas essenciais para muitos cenários.
* **Performance:** A indexação é o fator mais importante para a velocidade de leitura.
* **Analítica:** Window Functions e CTEs são ferramentas padrão para análise moderna.
* **Segurança:** Prepared statements são obrigatórios para qualquer aplicação.
* **Complexidade:** Os sistemas modernos são híbridos (Persistência Poliglota).
