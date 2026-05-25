import sqlite3
import os

def lab3_portable():
    db_file = 'lab_portable.db'
    
    # --- Part 1: SQLite File ---
    print("--- Part 1: SQLite File ---")
    if os.path.exists(db_file):
        os.remove(db_file)
    
    conn = sqlite3.connect(db_file)
    conn.execute("CREATE TABLE test (id INTEGER PRIMARY KEY, val TEXT)")
    conn.execute("INSERT INTO test (val) VALUES ('Persistent Data')")
    conn.commit()
    conn.close()
    print(f"Created {db_file} and inserted data.")
    
    # Re-open and check
    conn = sqlite3.connect(db_file)
    res = conn.execute("SELECT * FROM test").fetchone()
    print(f"Re-opened file: {res}")
    conn.close()

    # --- Part 2: SQLite Memory ---
    print("\n--- Part 2: SQLite Memory ---")
    # Using :memory: tells SQLite to keep it in RAM
    conn_mem = sqlite3.connect(':memory:')
    conn_mem.execute("CREATE TABLE test (id INTEGER PRIMARY KEY, val TEXT)")
    conn_mem.execute("INSERT INTO test (val) VALUES ('Volatile Data')")
    res = conn_mem.execute("SELECT * FROM test").fetchone()
    print(f"In-memory data: {res}")
    conn_mem.close()
    
    # Try to "re-open" (which is just a new connection to a new memory DB)
    conn_mem2 = sqlite3.connect(':memory:')
    try:
        res = conn_mem2.execute("SELECT * FROM test").fetchone()
    except sqlite3.OperationalError:
        print("Expected Result: Table 'test' does not exist in the new memory connection.")
    conn_mem2.close()

if __name__ == "__main__":
    lab3_portable()
