-- Advanced SQL queries for class 12

-- 1. Aggregations
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM students WHERE dept_id = 1;
SELECT AVG(age) FROM students;
SELECT MIN(age), MAX(age) FROM students;
SELECT dept_id, COUNT(*) FROM students GROUP BY dept_id;

-- 2. Subqueries and Views
SELECT name FROM students WHERE dept_id IN (
    SELECT dept_id FROM students GROUP BY dept_id HAVING COUNT(*) > 2
);

SELECT name FROM departments WHERE id NOT IN (
    SELECT DISTINCT dept_id FROM students
);

CREATE VIEW student_details AS
SELECT s.name as student_name, d.name as dept_name
FROM students s
JOIN departments d ON s.dept_id = d.id;

-- 3. Indexes
CREATE INDEX idx_student_name ON students(name);
EXPLAIN QUERY PLAN SELECT * FROM students WHERE name = 'Alice';
