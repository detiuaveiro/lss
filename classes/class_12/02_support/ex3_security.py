import sqlite3

# VULNERABLE CODE
def delete_user_vulnerable(user_id):
    # Malicious input: "1; DROP TABLE users;"
    query = f"DELETE FROM users WHERE id = {user_id}"
    print(f"Executing: {query}")

# SECURE CODE
def delete_user_secure(user_id):
    conn = sqlite3.connect(":memory:")
    cursor = conn.cursor()
    # Using prepared statement (placeholder ?)
    cursor.execute("DELETE FROM users WHERE id = ?", (user_id,))
    conn.commit()
    print("Executed securely")

if __name__ == "__main__":
    # Example of what a malicious user would type
    malicious_input = "1; DROP TABLE users;"
    delete_user_vulnerable(malicious_input)
    # delete_user_secure(malicious_input) # This would fail safely because '1; DROP...' is not an integer ID
