import sqlite3

def normalization_solution():
    conn = sqlite3.connect('university.db')
    cursor = conn.cursor()

    print("--- Exercise 6: Normalization Challenge ---")

    # Raw data from the table
    raw_data = [
        ('Alice', 'Databases', 'Dr. Smith', 'Room 101', 'A'),
        ('Alice', 'Physics', 'Dr. Brown', 'Room 202', 'B'),
        ('Bob', 'Databases', 'Dr. Smith', 'Room 101', 'C'),
    ]

    print("Processing raw data into normalized schema...")

    for stud_name, course_name, instr_name, office, grade in raw_data:
        # 1. Ensure Student exists
        cursor.execute('SELECT id FROM Student WHERE name = ?', (stud_name,))
        res = cursor.fetchone()
        if not res:
            cursor.execute('INSERT INTO Student (name) VALUES (?)', (stud_name,))
            stud_id = cursor.lastrowid
        else:
            stud_id = res[0]

        # 2. Ensure Teacher exists
        cursor.execute('SELECT id FROM Teacher WHERE name = ?', (instr_name,))
        res = cursor.fetchone()
        if not res:
            # We assume dept_id=1 for this exercise
            cursor.execute('INSERT INTO Teacher (name, dept_id) VALUES (?, ?)', (instr_name, 1))
            teach_id = cursor.lastrowid
        else:
            teach_id = res[0]

        # 3. Ensure Course exists
        cursor.execute('SELECT id FROM Course WHERE name = ?', (course_name,))
        res = cursor.fetchone()
        if not res:
            cursor.execute('INSERT INTO Course (name, dept_id, teacher_id) VALUES (?, ?, ?)', (course_name, 1, teach_id))
            course_id = cursor.lastrowid
        else:
            course_id = res[0]

        # 4. Enroll Student (Note: our Enrollment table doesn't have a Grade column in the schema, 
        # but we could add it. For now, let's just enroll).
        try:
            cursor.execute('INSERT INTO Enrollment (stud_id, course_id) VALUES (?, ?)', (stud_id, course_id))
        except sqlite3.IntegrityError:
            # Already enrolled
            pass

    conn.commit()
    print("Normalized data imported successfully.")

    # Verify
    print("\nVerification of Normalized Data:")
    cursor.execute('''
    SELECT Student.name, Course.name, Teacher.name
    FROM Student
    JOIN Enrollment ON Student.id = Enrollment.stud_id
    JOIN Course ON Enrollment.course_id = Course.id
    JOIN Teacher ON Course.teacher_id = Teacher.id
    ''')
    for row in cursor.fetchall():
        print(f" - Student: {row[0]}, Course: {row[1]}, Teacher: {row[2]}")

    conn.close()

if __name__ == "__main__":
    normalization_solution()
