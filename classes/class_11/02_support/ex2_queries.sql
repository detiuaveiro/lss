-- SQL Queries for class 11

-- 1. Select all students
SELECT * FROM students;

-- 2. Select students older than 21
SELECT * FROM students WHERE age > 21;

-- 3. Select names alphabetically
SELECT name FROM students ORDER BY name ASC;

-- 4. Update age
UPDATE students SET age = 21 WHERE name = 'Alice';

-- 5. Delete a student
DELETE FROM students WHERE name = 'Bob';

-- 6. Inner Join
SELECT students.name, departments.name
FROM students
INNER JOIN departments ON students.dept_id = departments.id;

-- 7. Left Join
SELECT departments.name, students.name
FROM departments
LEFT JOIN students ON departments.id = students.dept_id;
