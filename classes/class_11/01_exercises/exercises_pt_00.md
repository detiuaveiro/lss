---
title: Bases de Dados Relacionais e SQL I
---

# Exercícios

## Exercício 1: Configurar o SQLite

O SQLite é uma base de dados leve, baseada em ficheiros. Não requer um servidor.

1.  Abra o seu terminal.
2.  Crie um novo ficheiro de base de dados chamado `university.db`:
    ```bash
    $ sqlite3 university.db
    ```
3.  Está agora na consola do SQLite (`sqlite>`). Escreva `.help` para ver os comandos disponíveis.
4.  Escreva `.tables` para ver as tabelas atuais (deve estar vazio).

-----

## Exercício 2: Definir o Esquema (DDL)

1.  Crie uma tabela para `departments` (departamentos):
    ```sql
    CREATE TABLE departments (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL UNIQUE
    );
    ```
2.  Crie uma tabela para `students` (estudantes) com uma chave estrangeira para os departamentos:
    ```sql
    CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER,
        dept_id INTEGER,
        FOREIGN KEY (dept_id) REFERENCES departments(id)
    );
    ```
3.  Verifique se as tabelas foram criadas usando `.tables` e `.schema students`.

-----

## Exercício 3: Gerir Dados (DML)

1.  Insira três departamentos: `Computer Science`, `Physics`, e `Mathematics`.
2.  Insira pelo menos cinco estudantes, atribuindo-os a diferentes departamentos.
    ```sql
    INSERT INTO students (name, age, dept_id) VALUES ('Alice', 20, 1);
    ```
3.  Tente inserir um estudante com uma idade de -5 (se adicionou uma restrição CHECK) ou um estudante com um ID duplicado. Observe o que acontece.

-----

## Exercício 4: Consultar Dados

Escreva consultas SQL para:
1.  Selecionar todos os estudantes.
2.  Selecionar estudantes com mais de 21 anos.
3.  Selecionar nomes de estudantes por ordem alfabética.
4.  Atualizar a idade de um estudante.
5.  Apagar um estudante da base de dados.

-----

## Exercício 5: Junção de Tabelas (Joins)

1.  Execute um `INNER JOIN` para mostrar o nome de cada estudante ao lado do nome do seu departamento.
    ```sql
    SELECT students.name, departments.name
    FROM students
    INNER JOIN departments ON students.dept_id = departments.id;
    ```
2.  Execute um `LEFT JOIN` entre departamentos e estudantes. O que acontece aos departamentos que não têm estudantes?
3.  (Opcional) Use `.mode column` e `.headers on` no SQLite para tornar o output mais legível.
