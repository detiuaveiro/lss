# Bases de Dados Relacionais (RDBMS)

## Introdução

No centro da gestão de dados moderna reside o conceito de base de dados: um conjunto estruturado de informação mantido num sistema computacional, concebido para permitir o armazenamento, a recuperação e a manipulação eficiente de grandes volumes de dados. Ao longo das décadas, a representação de dados evoluiu de ficheiros planos (*flat files*) e estruturas hierárquicas para o **Modelo Relacional**, que se tornou o padrão da indústria devido à sua robustez, flexibilidade e rigor matemático.

Um **Sistema de Gestão de Bases de Dados Relacionais (RDBMS - *Relational Database Management System*)** é a camada de software que implementa o modelo relacional. O RDBMS atua como um intermediário entre as aplicações e os dados físicos, garantindo que a integridade da informação seja mantida e que o acesso multutilizador seja gerido sem conflitos. Exemplos proeminentes incluem o **SQLite** (ideal para aplicações embebidas e testes), **PostgreSQL** e **MySQL** (estandartes para serviços web), e o **Oracle DB** ou **SQL Server** (focados em ambiente empresarial).

---

## Parte 1: Fundamentos do Modelo Relacional

### A Teoria de Codd e a Estrutura de Tabelas

Proposto por Edgar F. Codd em 1970, o modelo relacional organiza a informação em **relações**, mais conhecidas como **tabelas**. Cada tabela é composta por:
*   **Atributos (Colunas):** Definem as propriedades dos dados (ex: Nome, Idade). Cada coluna possui um tipo de dado fixo (Inteiro, Texto, Data).
*   **Tuplos (Linhas/Registos):** Representam uma instância única de um objeto na tabela.
*   **Domínio:** O conjunto de valores permitidos para um atributo.

### Chaves e Integridade

Para garantir que os dados sejam únicos e que as relações entre tabelas sejam consistentes, utilizamos chaves:
1.  **Chave Primária (*Primary Key* - PK):** Um atributo (ou conjunto de atributos) que identifica de forma unívoca cada linha de uma tabela. Não pode haver valores duplicados nem nulos na PK.
2.  **Chave Estrangeira (*Foreign Key* - FK):** Um atributo numa tabela que faz referência à PK de outra tabela. A FK é a ferramenta que cria a "relação" entre entidades, garantindo a **integridade referencial** (não pode existir um registo "filho" sem um "pai" correspondente).

### Cardinalidade das Relações

As relações entre entidades podem assumir três formas principais:
*   **Um-para-Um (1:1):** Cada registo da Tabela A relaciona-se com exatamente um da Tabela B (ex: Uma Universidade $\to$ Um Reitor).
*   **Um-para-Muitos (1:N):** Um registo da Tabela A pode relacionar-se com vários da Tabela B (ex: Um Departamento $\to$ Vários Professores).
*   **Muitos-para-Muitos (N:M):** Vários registos de A relacionam-se com vários de B. Este tipo de relação requer obrigatoriamente uma **Tabela de Junção** (ou tabela associativa) para decompor a relação N:M em duas relações 1:N.

```{=latex}
\begin{center}
\begin{tikzpicture}[node distance=2cm, every node/.style={transform shape, font=\sffamily\small}, 
    box/.style={rectangle, draw, fill=blue!10, minimum width=2.5cm, minimum height=0.8cm}]
    
    % 1:1
    \node[box] (u) {Universidade};
    \node[box, right=of u] (r) {Reitor};
    \draw (u) -- (r) node[midway, above] {1 : 1};
    
    % 1:N
    \node[box, below=of u] (d) {Departamento};
    \node[box, right=of d] (t) {Professor};
    \draw (d) -- (t) node[midway, above] {1 : N};
    
    % N:M
    \node[box, below=of d] (s) {Aluno};
    \node[box, fill=red!10, right=of s] (en) {Inscrição};
    \node[box, right=of en] (c) {Cadeira};
    \draw (s) -- (en) node[midway, above] {1 : N};
    \draw (en) -- (c) node[midway, above] {N : 1};
    
    \node[below=0.2cm of en, font=\tiny\itshape, red] {Tabela de Junção};
\end{tikzpicture}
\end{center}
```

---

## Parte 2: Álgebra Relacional

Antes de escrever SQL, é fundamental compreender a **Álgebra Relacional**, a base matemática do modelo relacional. Ela define operações que tomam uma ou mais relações como entrada e produzem uma nova relação como saída.

### Operações Fundamentais

1.  **Seleção ($\sigma$):** Filtra as linhas de uma tabela com base num predicado. 
    *   *Exemplo:* $\sigma_{\text{idade} > 20}(\text{Alunos})$ retorna apenas alunos com mais de 20 anos.
2.  **Projeção ($\pi$):** Seleciona colunas específicas, eliminando as restantes.
    *   *Exemplo:* $\pi_{\text{nome, email}}(\text{Alunos})$ retorna apenas a lista de nomes e emails.
3.  **Junção (*Join* $\bowtie$):** Combina duas tabelas com base num atributo comum. É a operação mais poderosa, permitindo reconstruir a informação dispersa por várias tabelas.
    *   *Exemplo:* $\text{Alunos} \bowtie_{\text{Alunos.id=Inscricoes.id}} \text{Inscricoes}$ associa cada aluno às suas inscrições.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1cm,
    table/.style={draw, rectangle, minimum width=2cm, minimum height=1cm, align=center, font=\sffamily\tiny},
    arrow/.style={-stealth, thick}
]
    % Selection
    \node (t1) [table, fill=gray!10] {Tabela A \\ (100 linhas)};
    \node (op1) [circle, draw, fill=blue!10, right=of t1] {$\sigma$};
    \node (res1) [table, fill=blue!5, right=of op1] {Resultado \\ (10 linhas)};
    \draw [arrow] (t1) -- (op1);
    \draw [arrow] (op1) -- (res1);
    \node [above=0.1cm of op1, font=\tiny] {Filtro};

    % Projection
    \begin{scope}[yshift=-2cm]
        \node (t2) [table, fill=gray!10] {Tabela A \\ (5 colunas)};
        \node (op2) [circle, draw, fill=green!10, right=of t2] {$\pi$};
        \node (res2) [table, fill=green!5, right=of op2] {Resultado \\ (2 colunas)};
        \draw [arrow] (t2) -- (op2);
        \draw [arrow] (op2) -- (res2);
        \node [above=0.1cm of op2, font=\tiny] {Seleção de Atributos};
    \end{scope}
\end{tikzpicture}
\end{center}
```

### Correspondência entre Álgebra Relacional e SQL

Para facilitar a transição da teoria matemática para a prática, a tabela abaixo mapeia os operadores fundamentais para as correspondentes instruções SQL:

| Operação | Símbolo | Cláusula SQL Equivalente |
| :--- | :---: | :--- |
| **Seleção** | $\sigma$ | `WHERE` (filtragem de registos/linhas) |
| **Projeção** | $\pi$ | `SELECT` (seleção de colunas/atributos) |
| **Junção** | $\bowtie$ | `JOIN ... ON` (combinação de tabelas por chave) |

#### Exemplo Prático de Tradução:
Considere que pretendemos obter o `nome` e o `cargo` de todos os trabalhadores que pertencem à relação `Funcionarios` e cujo `salario` seja superior a 2000€.

* **Expressão na Álgebra Relacional:**
  $$\pi_{\text{nome, cargo}}(\sigma_{\text{salario} > 2000}(\text{Funcionarios}))$$

* **Instrução correspondente em SQL:**
  ```sql
  SELECT nome, cargo
  FROM Funcionarios
  WHERE salario > 2000;
  ```

---

## Parte 3: SQL (*Structured Query Language*)

O SQL é a linguagem declarativa utilizada para interagir com RDBMS. Ao contrário das linguagens imperativas, no SQL dizemos **o que** queremos obter, e o motor da base de dados decide **como** recuperar a informação de forma eficiente.

### Sublinguagens do SQL

O SQL é dividido em subcategorias conforme o objetivo da operação:
*   **DQL (*Data Query Language*):** Utilizada para a recuperação de dados. O comando central é o `SELECT`.
*   **DML (*Data Manipulation Language*):** Utilizada para alterar os dados. Inclui `INSERT` (adicionar), `UPDATE` (modificar) e `DELETE` (remover).
*   **DDL (*Data Definition Language*):** Utilizada para definir a estrutura (esquema) da base de dados. Inclui `CREATE TABLE`, `ALTER TABLE` e `DROP TABLE`.
*   **DCL (*Data Control Language*):** Gere as permissões de acesso via `GRANT` e `REVOKE`.
*   **TCL (*Transaction Control Language*):** Gere as transações para garantir as propriedades ACID através de `COMMIT` e `ROLLBACK`.

### O Ciclo de Vida de uma Query e as Propriedades ACID

Para garantir que a base de dados permaneça consistente mesmo perante falhas, os RDBMS implementam as propriedades **ACID**:
*   **Atomicidade:** A transação é tratada como uma unidade única; ou tudo é executado com sucesso, ou nada é aplicado.
*   **Consistência:** Uma transação nunca deixa a base de dados num estado inválido.
*   **Isolamento:** Transações simultâneas não interferem entre si.
*   **Durabilidade:** Uma vez confirmado (*committed*), o dado é permanente, mesmo em caso de falha de energia.

---

## Parte 4: SQL Avançado e Segurança

### Procedimentos Armazenados (*Stored Procedures*) e Triggers

Para otimizar a performance e a manutenção, podemos mover a lógica de negócio do código da aplicação para dentro da base de dados:
*   **Stored Procedures:** Blocos de código SQL pré-compilados que podem ser executados no servidor. Reduzem o tráfego de rede e aumentam a segurança.
*   **Triggers:** Procedimentos que são disparados automaticamente quando ocorre um evento específico (ex: disparar um log sempre que um registo na tabela `Utilizadores` for eliminado).

### Segurança: Prevenindo SQL Injection

Um dos ataques mais comuns e devastadores é a **SQL Injection**, onde um atacante insere código SQL malicioso em campos de entrada de texto para manipular a query final.

**Exemplo de Código Vulnerável:**
```python
# PERIGOSO: Concatenação direta de strings
query = "SELECT * FROM users WHERE name = '" + user_input + "';"
# Se user_input for: ' OR '1'='1
# A query torna-se: SELECT * FROM users WHERE name = '' OR '1'='1'; (Retorna todos os utilizadores)
```

A solução definitiva é a utilização de **Prepared Statements** (Declarações Preparadas). Neste modelo, a query é enviada para o servidor com *placeholders* (`?`), e os dados são enviados separadamente. O motor da base de dados trata os dados estritamente como valores, e nunca como código executável.

```{=latex}
\begin{center}
\begin{tikzpicture}[
    node distance=1cm,
    block/.style={draw, rectangle, minimum width=2.5cm, minimum height=1.1cm, align=center, font=\sffamily\tiny},
    arrow/.style={-stealth, thick}
]
    % Vulnerable Path
    \node (input1) [block, fill=red!10] {Input do Utilizador \\ \tiny{ ' OR '1'='1 '}};
    \node (concat) [block, fill=red!20, right=of input1] {Concatenação \\ \tiny{String + String}};
    \node (vuln) [block, fill=red!30, right=of concat] {Query Maliciosa \\ \tiny{Acesso total}};
    \draw [arrow] (input1) -- (concat);
    \draw [arrow] (concat) -- (vuln);

    % Secure Path
    \begin{scope}[yshift=-2.2cm]
        \node (input2) [block, fill=green!10] {Input do Utilizador \\ \tiny{ ' OR '1'='1 '}};
        \node (prep) [block, fill=green!20, right=of input2] {Prepared Statement \\ \tiny{Parametrizado}};
        \node (safe) [block, fill=green!30, right=of prep] {Query Segura \\ \tiny{Trata como texto}};
        \draw [arrow] (input2) -- (prep);
        \draw [arrow] (prep) -- (safe);
    \end{scope}
    
    \node [left=0.5cm of input1, font=\bfseries\small] {Ataque};
    \node [left=0.5cm of input2, font=\bfseries\small] {Defesa};
\end{tikzpicture}
\end{center}
```

---

## Parte 5: Casos de Uso e Aplicações Industriais

Os RDBMS são a escolha ideal para sistemas onde a **integridade dos dados** e a **consistência** são prioritárias sobre a escalabilidade horizontal massiva:
*   **Sistemas Bancários:** Onde transações financeiras exigem atomicidade absoluta (ACID).
*   **Sistemas de Inventário e ERP:** Onde a consistência entre stocks e vendas deve ser rigorosa.
*   **Registos Académicos:** Onde as relações entre alunos, cursos e notas devem ser precisas e auditáveis.

Para cenários de Big Data ou dados altamente variáveis, recorre-se a modelos NoSQL, que serão detalhados no próximo capítulo.

---

## Recursos Adicionais

*   **Aprendizagem Interativa:** [SQLZoo](https://sqlzoo.net/) e [Mode SQL Tutorial](https://mode.com/sql-tutorial/).
*   **Documentação Técnica:** [PostgreSQL Documentation](https://www.postgresql.org/docs/).
*   **Segurança:** [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html).
*   **Prática:** [LeetCode SQL Problems](https://leetcode.com/study-plan/sql/).
