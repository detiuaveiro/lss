---
title: Bases de Dados Relacionais e SQL I
---

# Introdução

## O que é uma Base de Dados?

Um conjunto estruturado de dados mantido num computador, especialmente um que seja acessível de várias formas.

* **Objetivo:** Armazenar, recuperar e gerir grandes quantidades de informação.
* **Evolução:**
  * **Flat files:** CSV/Texto (Rápido mas limitado).
  * **Hierárquico:** Estrutura em árvore (IBM IMS).
  * **Relacional:** Tabelas com relações (O padrão desde os anos 80).
  * **NoSQL:** Esquemas flexíveis para big data (MongoDB, Redis).

## O que é um RDBMS?

Um **Sistema de Gestão de Bases de Dados Relacionais (RDBMS)** é a camada de software que gere as bases de dados relacionais.

* Fornece uma interface entre utilizadores/aplicações e os dados.
* Exemplos: **SQLite, PostgreSQL, MySQL, Oracle, Microsoft SQL Server**.
* Impõe o **Modelo Relacional**, a integridade dos dados e gere o acesso multutilizador.

## RDBMS vs DB vs Modelo Relacional

* **Modelo Relacional:** A estrutura teórica (Codd, 1970) que utiliza tabelas (relações).
* **Base de Dados (DB):** A coleção real de dados (ex: o ficheiro `university.db`).
* **RDBMS:** O motor/software (ex: `sqlite3` ou `PostgreSQL`) que gere a DB usando o Modelo Relacional.

| Conceito | Natureza | Responsabilidade |
| :--- | :--- | :--- |
| **Modelo Relacional** | Teoria | Define estruturas (Tabelas, Chaves). |
| **Base de Dados (DB)** | Dados | Os valores armazenados e metadados. |
| **RDBMS** | Software | Execução, Segurança, Integridade, ACID. |

# Vantagens do RDBMS

## Propriedades ACID I

Um RDBMS garante a integridade dos dados através do ACID:

* **Atomicidade:** "Tudo ou nada." Se qualquer parte de uma transação falhar, toda a transação é revertida.
* **Consistência:** A base de dados deve transitar de um estado válido para outro, seguindo todas as regras (restrições).

## Propriedades ACID II

* **Isolamento:** Transações simultâneas não interferem; parecem correr sequencialmente.
* **Durabilidade:** Uma vez confirmada (committed), os dados são permanentes, sobrevivendo a falhas do sistema.

# O Modelo Relacional

## Cenário Universitário

Para compreender estes conceitos, utilizaremos o cenário de uma **Base de Dados Universitária**:

* **University (Universidade):** A instituição.
* **Rector (Reitor):** O chefe da universidade (relação 1:1).
* **Department (Departamento):** Unidades organizacionais (Engenharia, Artes).
* **Teacher (Professor):** Pessoal afeto aos departamentos.
* **Course (Cadeira):** Disciplinas oferecidas pelos departamentos.
* **Student (Aluno):** Indivíduos inscritos nas cadeiras (relação N:M).

## Diagrama Entidade-Relação (ER)

\begin{center}
\begin{tikzpicture}[node distance=1.0cm, scale=0.6, every node/.style={transform shape}, 
    entity/.style={rectangle, draw, fill=blue!10, minimum width=2.4cm, minimum height=0.8cm},
    relationship/.style={diamond, draw, fill=red!10, aspect=2, inner sep=0pt, minimum width=2.4cm},
    attr/.style={ellipse, draw, fill=yellow!10, inner sep=1pt}]
    
    \node[entity] (univ) {University};
    \node[relationship, right=of univ] (has_r) {Tem};
    \node[entity, right=of has_r] (rect) {Reitor};
    \node[relationship, below=of univ] (has_d) {Tem};
    \node[entity, below=of has_d] (dept) {Department};
    \node[relationship, below=of dept] (offers) {Oferece};
    \node[entity, below=of offers] (course) {Course};
    \node[relationship, left=of course] (enrolled) {Inscrito};
    \node[entity, left=of enrolled] (stud) {Student};
    \node[relationship, right=of course] (teaches) {Leciona};
    \node[entity, right=of teaches] (teach) {Teacher};
    
    \draw (univ) -- (has_r);
    \draw (has_r) -- (rect);
    \draw (univ) -- (has_d);
    \draw (has_d) -- (dept);
    \draw (dept) -- (offers);
    \draw (offers) -- (course);
    \draw (course) -- (enrolled);
    \draw (enrolled) -- (stud);
    \draw (course) -- (teaches);
    \draw (teaches) -- (teach);
    \draw (teach) |- (dept);
\end{tikzpicture}
\end{center}

## Conceitos Base I

Proposto por Edgar F. Codd in 1970, organiza os dados em uma ou mais tabelas.

* **Tabela (Relação):** Uma coleção de elementos de dados organizados em linhas e colunas.
* **Linha (Tuplo/Registo):** Representa um item único na tabela.
* **Coluna (Atributo/Campo):** Representa uma propriedade específica dos itens.

## Conceitos Base II

\begin{center}
\begin{tikzpicture}[node distance=0cm, outer sep=0pt, scale=0.8, every node/.style={transform shape}]
    \tikzstyle{cell} = [rectangle, draw, minimum width=2.5cm, minimum height=0.8cm]
    \tikzstyle{header} = [cell, fill=gray!20, font=\bfseries]
    \matrix (m) [matrix of nodes, ampersand replacement=\&, nodes={cell}, row 1/.style={nodes={header}}] {
        ID \& Nome \& DeptID \\
        1 \& Alice \& 10 \\
        2 \& Bob \& 10 \\
        3 \& Charlie \& 20 \\
    };
    \draw[red, ultra thick] (m-2-1.north west) rectangle (m-2-3.south east);
    \node[right=0.5cm of m-2-3, red] (row) {\textbf{Linha (Tuplo)}};
    \draw[red, ultra thick, ->] (row) -- (m-2-3.east);
    \draw[blue, ultra thick] (m-1-2.north west) rectangle (m-4-2.south east);
    \node[above=0.5cm of m-1-2, blue] (col) {\textbf{Coluna (Atributo)}};
    \draw[blue, ultra thick, ->] (col) -- (m-1-2.north);
\end{tikzpicture}
\end{center}

## Relações em Bases de Dados I: 1:1

* **Um-para-Um (1:1):** Uma entidade está relacionada com exatamente uma outra.
* Exemplo: Uma **University** tem um **Reitor**.

\begin{center}
\begin{tikzpicture}[node distance=1.5cm, every node/.style={transform shape, font=\small}, 
    box/.style={rectangle, draw, fill=blue!10, minimum width=2.5cm, minimum height=0.8cm}]
    \node[box] (univ) {University};
    \node[box, right=2.5cm of univ] (rect) {Reitor};
    \draw (univ) -- (rect) node[midway, below=2pt] {Tem} node[pos=0.1, above] {1} node[pos=0.9, above] {1};
\end{tikzpicture}
\end{center}

## Relações em Bases de Dados II: 1:N

* **Um-para-Muitos (1:N):** Uma entidade pode estar relacionada com muitas instâncias de outra.
* Exemplo: Um **Department** tem muitos **Teachers**.

\begin{center}
\begin{tikzpicture}[node distance=1.5cm, every node/.style={transform shape, font=\small}, 
    box/.style={rectangle, draw, fill=blue!10, minimum width=2.5cm, minimum height=0.8cm}]
    \node[box] (dept) {Department};
    \node[box, right=2.5cm of dept] (teach) {Teacher};
    \draw (dept) -- (teach) node[midway, below=2pt] {Emprega} node[pos=0.1, above] {1} node[pos=0.9, above] {N};
\end{tikzpicture}
\end{center}

## Relações em Bases de Dados III: N:M

* **Muitos-para-Muitos (N:M):** Muitas instâncias de uma entidade relacionam-se com muitas de outra.
* Exemplo: Muitos **Students** inscrevem-se em muitas **Courses**.

\begin{center}
\begin{tikzpicture}[node distance=1.2cm, scale=0.8, every node/.style={transform shape, font=\small}, 
    box/.style={rectangle, draw, fill=blue!10, minimum width=2.2cm, minimum height=0.8cm}]
    \node[box] (stud) {Student};
    \node[box, right=1.8cm of stud, fill=red!10] (enroll) {Inscrição};
    \node[box, right=1.8cm of enroll] (course) {Course};
    \draw (stud) -- (enroll) node[pos=0.1, above] {1} node[pos=0.9, above] {N};
    \draw (enroll) -- (course) node[pos=0.1, above] {N} node[pos=0.9, above] {1};
    \node[below=0.5cm of enroll, font=\footnotesize, red] {Tabela de Junção};
\end{tikzpicture}
\end{center}

# SQL: Structured Query Language

## Sublinguagens SQL (6 Modelos) I

O SQL divide-se em várias sublinguagens para diferentes propósitos:

1.  **DQL (Data Query Language):** Para recuperar dados.
    * `SELECT`
2.  **DML (Data Manipulation Language):** Para modificar dados.
    * `INSERT`, `UPDATE`, `DELETE`
3.  **DDL (Data Definition Language):** Para definir o esquema.
    * `CREATE`, `ALTER`, `DROP`, `TRUNCATE`

## Sublinguagens SQL (6 Modelos) II

4.  **DCL (Data Control Language):** Para controlo de acessos/permissões.
    * `GRANT`, `REVOKE`
5.  **TCL (Transaction Control Language):** Para gerir transações.
    * `COMMIT`, `ROLLBACK`, `SAVEPOINT`
6.  **Administrativa/Metadados:** Para gerir o sistema ou inspecionar metadados.
    * `DESCRIBE`, `EXPLAIN`, `PRAGMA` (específico do SQLite)

## Tipos de Dados SQL

Tipos comuns usados em RDBMS (Padrão e SQLite):

* **INT / INTEGER:** Números inteiros.
* **VARCHAR(n) / TEXT:** Cadeias de caracteres.
* **REAL / FLOAT / DOUBLE:** Números decimais.
* **DATE / DATETIME:** Valores temporais.
* **BOOLEAN:** Verdadeiro/Falso (frequentemente 0/1 no SQLite).
* **BLOB:** Dados binários (imagens, ficheiros).

## Funções de Agregação SQL

Funções que realizam um cálculo sobre um conjunto de valores:

* **COUNT():** Retorna o número de linhas.
* **SUM():** Retorna a soma total de uma coluna numérica.
* **AVG():** Retorna o valor médio.
* **MIN() / MAX():** Retorna o valor mínimo/máximo.

```sql
SELECT COUNT(*) FROM Student;
SELECT AVG(id) FROM Course; -- Cálculo de exemplo
```

## Diagrama do Esquema Relacional

\begin{center}
\begin{tikzpicture}[node distance=0.8cm, scale=0.6, every node/.style={transform shape, font=\scriptsize}, 
    table/.style={rectangle, draw, fill=gray!10, minimum width=3.5cm, align=left}]
    
    \node[table] (univ) {\textbf{University} \\ \underline{id}: INT (PK) \\ name: TEXT};
    \node[table, right=of univ, xshift=1.5cm] (rect) {\textbf{Rector} \\ \underline{id}: INT (PK) \\ name: TEXT \\ univ\_id: INT (FK)};
    \node[table, below=of univ] (dept) {\textbf{Department} \\ \underline{id}: INT (PK) \\ name: TEXT \\ univ\_id: INT (FK)};
    \node[table, right=of dept, xshift=1.5cm] (teach) {\textbf{Teacher} \\ \underline{id}: INT (PK) \\ name: TEXT \\ dept\_id: INT (FK)};
    \node[table, below=of teach] (course) {\textbf{Course} \\ \underline{id}: INT (PK) \\ name: TEXT \\ dept\_id: INT (FK) \\ teacher\_id: INT (FK)};
    \node[table, left=of course, xshift=-1.5cm] (stud) {\textbf{Student} \\ \underline{id}: INT (PK) \\ name: TEXT};
    \node[table, below=of course] (enroll) {\textbf{Enrollment} \\ \underline{stud\_id}: INT (PK, FK) \\ \underline{course\_id}: INT (PK, FK)};

    \draw[->] (rect.west) -- (univ.east);
    \draw[->] (dept.north) -- (univ.south);
    \draw[->] (teach.west) -- (dept.east);
    \draw[->] (course.north) -- (teach.south);
    \draw[->] (course.west) -- (dept.south west);
    \draw[->] (enroll.west) -| (stud.south);
    \draw[->] (enroll.north) -- (course.south);
\end{tikzpicture}
\end{center}

# SQL de Fim-a-Fim: DDL (Esquema)

## DDL: Criar Tabelas I

```sql
CREATE TABLE University (
    id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL
);

CREATE TABLE Rector (
    id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
    univ_id INTEGER UNIQUE, FOREIGN KEY (univ_id) REFERENCES University(id)
);
```

## DDL: Criar Tabelas II

```sql
CREATE TABLE Department (
    id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
    univ_id INTEGER, FOREIGN KEY (univ_id) REFERENCES University(id)
);

CREATE TABLE Teacher (
    id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
    dept_id INTEGER, FOREIGN KEY (dept_id) REFERENCES Department(id)
);
```

## DDL: Criar Tabelas III

```sql
CREATE TABLE Course (
    id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
    dept_id INTEGER, teacher_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES Department(id),
    FOREIGN KEY (teacher_id) REFERENCES Teacher(id)
);

CREATE TABLE Student (
    id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL
);
```

## DDL: Criar Tabelas IV

```sql
CREATE TABLE Enrollment (
    stud_id INTEGER, course_id INTEGER,
    PRIMARY KEY (stud_id, course_id),
    FOREIGN KEY (stud_id) REFERENCES Student(id),
    FOREIGN KEY (course_id) REFERENCES Course(id)
);
```

# SQL de Fim-a-Fim: DML (Dados)

## DML: Inserir Dados I

```sql
INSERT INTO University (name) VALUES ('Univ. Aveiro');

INSERT INTO Rector (name, univ_id) VALUES ('Prof. Paulo', 1);

INSERT INTO Department (name, univ_id) VALUES ('DETI', 1), ('DMat', 1);

INSERT INTO Teacher (name, dept_id) VALUES ('Dr. Smith', 1), ('Dr. Taylor', 2);
```

## DML: Inserir Dados II

```sql
INSERT INTO Course (name, dept_id, teacher_id) 
VALUES ('Bases de Dados Relacionais', 1, 1), ('Álgebra Linear', 2, 2);

INSERT INTO Student (name) VALUES ('Alice'), ('Bob');

INSERT INTO Enrollment (stud_id, course_id) 
VALUES (1, 1), (1, 2), (2, 1);
```

## DML: Atualizações e Eliminações

```sql
-- Modificar registos existentes
UPDATE Teacher SET name = 'Prof. Smith' WHERE id = 1;

-- Remover registos
DELETE FROM Enrollment WHERE stud_id = 2 AND course_id = 2;
```

# SQL de Fim-a-Fim: DQL (Consultas)

## DQL: Consultas Básicas e Filtragem

```sql
-- Selecionar colunas específicas com um pseudónimo (alias)
SELECT name AS NomeAluno FROM Student;

-- Filtragem com WHERE
SELECT * FROM Course WHERE dept_id = 1;

-- Funções de Agregação
SELECT COUNT(*) FROM Enrollment WHERE course_id = 1;
```

## DQL: Consulta Complexa (Junções)

```sql
SELECT s.name AS Aluno, c.name AS Cadeira, t.name AS Professor, 
       d.name AS Dept, u.name AS Univ, r.name AS Reitor
FROM Student s
JOIN Enrollment e ON s.id = e.stud_id
JOIN Course c ON e.course_id = c.id
JOIN Teacher t ON c.teacher_id = t.id
JOIN Department d ON t.dept_id = d.id
JOIN University u ON d.univ_id = u.id
JOIN Rector r ON u.id = r.univ_id;
```

## Resultados Esperados I

| Aluno | Cadeira | Professor |
| :--- | :--- | :--- |
| Alice | Bases de Dados Relacionais | Prof. Smith |
| Alice | Álgebra Linear | Dr. Taylor |
| Bob | Bases de Dados Relacionais | Prof. Smith |

## Resultados Esperados II

| Dept | Univ | Reitor |
| :--- | :--- | :--- |
| DETI | Univ. Aveiro | Prof. Paulo |
| DMat | Univ. Aveiro | Prof. Paulo |
| DETI | Univ. Aveiro | Prof. Paulo |

# Outros Modelos SQL

## DCL: Data Control Language

Gere acessos e permissões (Concetual em alguns RDBMS):

```sql
-- Conceder acesso de leitura a um professor
GRANT SELECT ON Student TO 'user_professor';

-- Revogar permissões de eliminação aos alunos
REVOKE DELETE ON Course FROM 'role_aluno';
```

## TCL: Transaction Control Language

Garante as propriedades ACID ao agrupar instruções:

```sql
BEGIN TRANSACTION;
INSERT INTO Student (name) VALUES ('Eve');
-- Se o sistema falhar aqui, Eve NÃO é adicionada permanentemente
COMMIT; -- Guarda as alterações

-- Ou reverter se for detetado um erro:
-- ROLLBACK;
```

## Administrativo & Metadados

Comandos para gerir o próprio motor de base de dados:

```sql
-- MySQL / PostgreSQL:
EXPLAIN SELECT * FROM Student;
DESCRIBE Course;

-- SQLite:
PRAGMA foreign_keys = ON;
PRAGMA table_info('Student');
```

# Sumário

## Sumário

* **RDBMS:** Camada de software (SQLite) que impõe o **Modelo Relacional**.
* **ACID:** Vantagens fundamentais (Atomicidade, Consistência, Isolamento, Durabilidade).
* **Modelos SQL:** DQL, DML, DDL, DCL, TCL e Administrativo.
* **Estrutura:** Relações PK/FK visualizadas via diagramas ER e de Cardinalidade.

