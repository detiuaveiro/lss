import requests

try:
    response = requests.get('https://jsonplaceholder.typicode.com/todos/1', timeout=5)
    if response.status_code == 200:
        data = response.json()
        print(f"Task Title: {data['title']}")
    else:
        print(f"Error: Received status code {response.status_code}")
except Exception as e:
    print(f"Failed to connect to API: {e}")
