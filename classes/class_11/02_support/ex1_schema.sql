-- Schema setup for university database

-- Create departments table
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Create students table
CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER,
    dept_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departments(id)
);

-- Insert data
INSERT INTO departments (name) VALUES ('Computer Science');
INSERT INTO departments (name) VALUES ('Physics');
INSERT INTO departments (name) VALUES ('Mathematics');

INSERT INTO students (name, age, dept_id) VALUES ('Alice', 20, 1);
INSERT INTO students (name, age, dept_id) VALUES ('Bob', 22, 1);
INSERT INTO students (name, age, dept_id) VALUES ('Charlie', 21, 2);
INSERT INTO students (name, age, dept_id) VALUES ('David', 23, 3);
INSERT INTO students (name, age, dept_id) VALUES ('Eve', 19, 1);
