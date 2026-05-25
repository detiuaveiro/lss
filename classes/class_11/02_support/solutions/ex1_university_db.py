import sqlite3
import os

def setup_database():
    db_file = 'university.db'
    
    # Remove existing database to start fresh
    if os.path.exists(db_file):
        os.remove(db_file)
        
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()

    print("--- Exercise 2: DDL (Creating Tables) ---")
    
    # University
    cursor.execute('CREATE TABLE University (id INTEGER PRIMARY KEY, name TEXT NOT NULL)')
    
    # Rector (1:1 with University)
    cursor.execute('''
    CREATE TABLE Rector (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        univ_id INTEGER UNIQUE,
        FOREIGN KEY (univ_id) REFERENCES University(id)
    )''')
    
    # Department
    cursor.execute('''
    CREATE TABLE Department (
        id INTEGER PRIMARY KEY, 
        name TEXT NOT NULL, 
        univ_id INTEGER,
        FOREIGN KEY (univ_id) REFERENCES University(id)
    )''')
    
    # Teacher
    cursor.execute('''
    CREATE TABLE Teacher (
        id INTEGER PRIMARY KEY, 
        name TEXT NOT NULL, 
        dept_id INTEGER,
        FOREIGN KEY (dept_id) REFERENCES Department(id)
    )''')
    
    # Course
    cursor.execute('''
    CREATE TABLE Course (
        id INTEGER PRIMARY KEY, 
        name TEXT NOT NULL, 
        dept_id INTEGER, 
        teacher_id INTEGER,
        FOREIGN KEY (dept_id) REFERENCES Department(id),
        FOREIGN KEY (teacher_id) REFERENCES Teacher(id)
    )''')
    
    # Student
    cursor.execute('CREATE TABLE Student (id INTEGER PRIMARY KEY, name TEXT NOT NULL)')
    
    # Enrollment
    cursor.execute('''
    CREATE TABLE Enrollment (
        stud_id INTEGER, 
        course_id INTEGER,
        PRIMARY KEY (stud_id, course_id),
        FOREIGN KEY (stud_id) REFERENCES Student(id),
        FOREIGN KEY (course_id) REFERENCES Course(id)
    )''')
    
    conn.commit()
    print("Tables created successfully.")

    print("\n--- Exercise 3: DML (Inserting Data) ---")
    
    # University
    cursor.execute('INSERT INTO University (name) VALUES (?)', ('University of Aveiro',))
    
    # Rector
    cursor.execute('INSERT INTO Rector (name, univ_id) VALUES (?, ?)', ('Prof. Paulo Jorge Ferreira', 1))
    
    # Departments
    cursor.execute('INSERT INTO Department (name, univ_id) VALUES (?, ?)', ('DETI', 1))
    cursor.execute('INSERT INTO Department (name, univ_id) VALUES (?, ?)', ('DMat', 1))
    
    # Teachers
    teachers = [('Dr. Smith', 1), ('Prof. Jones', 1), ('Dr. Taylor', 2)]
    cursor.executemany('INSERT INTO Teacher (name, dept_id) VALUES (?, ?)', teachers)
    
    # Courses
    courses = [
        ('Relational Databases', 1, 1),
        ('Computer Architecture', 1, 2),
        ('Linear Algebra', 2, 3),
        ('Calculus I', 2, 3)
    ]
    cursor.executemany('INSERT INTO Course (name, dept_id, teacher_id) VALUES (?, ?, ?)', courses)
    
    # Students
    students = [('Alice',), ('Bob',), ('Charlie',), ('David',), ('Eve',)]
    cursor.executemany('INSERT INTO Student (name) VALUES (?)', students)
    
    # Enrollments
    enrollments = [(1, 1), (1, 2), (2, 1), (3, 3), (4, 4), (5, 1)]
    cursor.executemany('INSERT INTO Enrollment (stud_id, course_id) VALUES (?, ?)', enrollments)
    
    conn.commit()
    print("Data inserted successfully.")

    print("\n--- Exercise 4: DQL (Querying Data) ---")
    
    print("\n1. Teachers and their departments:")
    cursor.execute('''
    SELECT Teacher.name, Department.name 
    FROM Teacher 
    JOIN Department ON Teacher.dept_id = Department.id
    ''')
    for row in cursor.fetchall():
        print(f" - {row[0]} works in {row[1]}")

    print("\n2. Comprehensive Student-to-Rector Join:")
    cursor.execute('''
    SELECT s.name, c.name, t.name, d.name, u.name, r.name
    FROM Student s
    JOIN Enrollment e ON s.id = e.stud_id
    JOIN Course c ON e.course_id = c.id
    JOIN Teacher t ON c.teacher_id = t.id
    JOIN Department d ON t.dept_id = d.id
    JOIN University u ON d.univ_id = u.id
    JOIN Rector r ON u.id = r.univ_id
    WHERE c.name = 'Relational Databases'
    ''')
    for row in cursor.fetchall():
        print(f" - {row[0]} takes {row[1]} (Teacher: {row[2]}, Dept: {row[3]}, Univ: {row[4]}, Rector: {row[5]})")

    print("\n3. Courses offered by 'DMat':")
    cursor.execute('''
    SELECT Course.name 
    FROM Course 
    JOIN Department ON Course.dept_id = Department.id
    WHERE Department.name = 'DMat'
    ''')
    for row in cursor.fetchall():
        print(f" - {row[0]}")

    print("\n4. Updating teacher name...")
    cursor.execute("UPDATE Teacher SET name = 'Prof. Alice Smith' WHERE id = 1")
    conn.commit()
    
    print("\n5. Deleting a course...")
    cursor.execute("DELETE FROM Course WHERE id = 4")
    conn.commit()
    print("Course deleted.")

    conn.close()

if __name__ == "__main__":
    setup_database()
