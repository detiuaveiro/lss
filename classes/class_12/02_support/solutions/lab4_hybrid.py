import psycopg2
import redis
import time
import json

# Connection settings (matching docker-compose)
PG_CONFIG = {
    "host": "localhost",
    "database": "class12",
    "user": "user",
    "password": "password"
}

def get_user_from_db(user_id):
    # Simulate a "slow" database query
    time.sleep(0.5) 
    conn = psycopg2.connect(**PG_CONFIG)
    cur = conn.cursor()
    cur.execute("SELECT id, username, balance FROM accounts WHERE id = %s", (user_id,))
    user = cur.fetchone()
    cur.close()
    conn.close()
    return user

def get_user_with_cache(user_id):
    r = redis.Redis(host='localhost', port=6379, decode_responses=True)
    
    # Try cache
    cached_user = r.get(f"user:{user_id}")
    if cached_user:
        print("Cache HIT!")
        return json.loads(cached_user)
    
    # Cache MISS
    print("Cache MISS! Fetching from DB...")
    user = get_user_from_db(user_id)
    if user:
        user_data = {"id": user[0], "username": user[1], "balance": user[2]}
        r.setex(f"user:{user_id}", 60, json.dumps(user_data))
        return user_data
    return None

# To run this, you need: pip install psycopg2-binary redis
# And docker-compose up -d
if __name__ == "__main__":
    print("--- Lab 4: Hybrid Arch (Cache-Aside) ---")
    try:
        # First request (Miss)
        start = time.time()
        print(get_user_with_cache(1))
        print(f"Time: {time.time() - start:.2f}s")

        # Second request (Hit)
        start = time.time()
        print(get_user_with_cache(1))
        print(f"Time: {time.time() - start:.2f}s")
    except Exception as e:
        print(f"Error: {e}")
        print("Note: Ensure Docker containers are running and database is initialized.")
