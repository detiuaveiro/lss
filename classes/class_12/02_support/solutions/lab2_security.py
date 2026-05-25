import sqlite3

def login_vulnerable(username, password):
    conn = sqlite3.connect('lab_security.db')
    cursor = conn.cursor()
    # EXTREMELY DANGEROUS - STRING CONCATENATION
    query = f"SELECT * FROM accounts WHERE username = '{username}' AND password = '{password}'"
    print(f"Executing: {query}")
    cursor.execute(query)
    result = cursor.fetchone()
    conn.close()
    return result

def login_secure(username, password):
    conn = sqlite3.connect('lab_security.db')
    cursor = conn.cursor()
    # SECURE - PREPARED STATEMENT
    query = "SELECT * FROM accounts WHERE username = ? AND password = ?"
    cursor.execute(query, (username, password))
    result = cursor.fetchone()
    conn.close()
    return result

print("--- Lab 2: Security (SQL Injection) ---")

# Normal Login
print("\n[Normal Login Attempt]")
res = login_vulnerable('alice', 'secret')
print(f"Result: {res}")

# SQL Injection Attack
print("\n[SQL Injection Attempt]")
# The attack string: ' OR '1'='1
res = login_vulnerable("admin' --", "anything")
print(f"Result: {res}")

# Secure attempt with attack string
print("\n[Secure Login with Attack String]")
res = login_secure("admin' --", "anything")
print(f"Result: {res}")
