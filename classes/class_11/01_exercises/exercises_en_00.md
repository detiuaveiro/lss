---
title: Relational Databases and SQL I
---

# Exercises

## Exercise 1: Setting up SQLite

SQLite is a lightweight, file-based database. It doesn't require a server.

1.  Open your terminal.
2.  Create a new database file named `university.db`:
    ```bash
    $ sqlite3 university.db
    ```
3.  You are now in the SQLite prompt (`sqlite>`). Type `.help` to see available commands.
4.  Type `.tables` to see current tables (should be empty).

-----

## Exercise 2: Defining the Schema (DDL)

1.  Create a table for `departments`:
    ```sql
    CREATE TABLE departments (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL UNIQUE
    );
    ```
2.  Create a table for `students` with a foreign key to departments:
    ```sql
    CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER,
        dept_id INTEGER,
        FOREIGN KEY (dept_id) REFERENCES departments(id)
    );
    ```
3.  Verify the tables were created using `.tables` and `.schema students`.

-----

## Exercise 3: Managing Data (DML)

1.  Insert three departments: `Computer Science`, `Physics`, and `Mathematics`.
2.  Insert at least five students, assigning them to different departments.
    ```sql
    INSERT INTO students (name, age, dept_id) VALUES ('Alice', 20, 1);
    ```
3.  Try to insert a student with an age of -5 (if you added a CHECK constraint) or a student with a duplicate ID. Observe what happens.

-----

## Exercise 4: Querying Data

Write SQL queries to:
1.  Select all students.
2.  Select students older than 21.
3.  Select names of students in alphabetical order.
4.  Update the age of one student.
5.  Delete one student from the database.

-----

## Exercise 5: Joining Tables

1.  Perform an `INNER JOIN` to show each student's name alongside their department name.
    ```sql
    SELECT students.name, departments.name
    FROM students
    INNER JOIN departments ON students.dept_id = departments.id;
    ```
2.  Perform a `LEFT JOIN` between departments and students. What happens to departments that have no students?
3.  (Optional) Use `.mode column` and `.headers on` in SQLite to make the output more readable.
