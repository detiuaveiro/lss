import sqlite3

def test_transactions():
    conn = sqlite3.connect('university.db')
    cursor = conn.cursor()

    print("--- Exercise 5: TCL (Transactions) ---")
    
    try:
        # Start transaction
        conn.execute('BEGIN TRANSACTION')
        
        print("Attempting to add a new student...")
        cursor.execute('INSERT INTO Student (name) VALUES (?)', ('New Student',))
        
        # Purposefully cause an error (table does not exist)
        print("Attempting an invalid operation to trigger rollback...")
        cursor.execute('INSERT INTO NonExistentTable (val) VALUES (1)')
        
        # If we reach here, commit
        conn.commit()
        print("Transaction committed.")
        
    except sqlite3.OperationalError as e:
        print(f"Caught expected error: {e}")
        conn.rollback()
        print("Transaction rolled back successfully.")
    
    # Verify the student was NOT added
    cursor.execute("SELECT * FROM Student WHERE name = 'New Student'")
    result = cursor.fetchone()
    if result is None:
        print("Verification: 'New Student' was NOT added to the database.")
    else:
        print("Verification FAILED: 'New Student' exists in the database.")

    conn.close()

if __name__ == "__main__":
    test_transactions()
