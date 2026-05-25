import sqlite3
import random
import string
import time

def setup_indexing_lab():
    print("Setting up Indexing Lab (SQLite)...")
    conn = sqlite3.connect('lab_indexing.db')
    cursor = conn.cursor()
    cursor.execute("DROP TABLE IF EXISTS users")
    cursor.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT, age INTEGER)")
    
    # Generate 100,000 records
    data = []
    for i in range(100000):
        name = ''.join(random.choices(string.ascii_letters, k=8))
        email = f"{name}@example.com"
        age = random.randint(18, 80)
        data.append((i, name, email, age))
    
    cursor.executemany("INSERT INTO users VALUES (?, ?, ?, ?)", data)
    conn.commit()
    conn.close()
    print("Done. Generated 100,000 records in lab_indexing.db")

def setup_security_lab():
    print("Setting up Security Lab (SQLite)...")
    conn = sqlite3.connect('lab_security.db')
    cursor = conn.cursor()
    cursor.execute("DROP TABLE IF EXISTS accounts")
    cursor.execute("CREATE TABLE accounts (id INTEGER PRIMARY KEY, username TEXT, password TEXT, balance REAL)")
    
    accounts = [
        ('admin', 'password123', 10000.0),
        ('alice', 'secret', 500.0),
        ('bob', '12345', 150.0)
    ]
    cursor.executemany("INSERT INTO accounts (username, password, balance) VALUES (?, ?, ?)", accounts)
    conn.commit()
    conn.close()
    print("Done. lab_security.db ready.")

if __name__ == "__main__":
    setup_indexing_lab()
    setup_security_lab()
