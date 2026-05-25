import sqlite3
import time

def run_query(conn, label):
    start = time.time()
    cursor = conn.cursor()
    # Searching for a random name (probability of existence is low, but forces a full scan if no index)
    cursor.execute("SELECT * FROM users WHERE name = 'nonexistent_name'")
    cursor.fetchall()
    end = time.time()
    print(f"{label}: {(end - start) * 1000:.2f} ms")

conn = sqlite3.connect('lab_indexing.db')

print("--- Lab 1: Indexing Impact ---")
# Before Index
run_query(conn, "Without Index")

# Create Index
print("Creating Index...")
conn.execute("CREATE INDEX idx_users_name ON users(name)")

# After Index
run_query(conn, "With Index")

conn.close()
