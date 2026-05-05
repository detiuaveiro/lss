# Solutions for Class 09 Exercises

## Exercise 1: Identifying Data Structure
1. **Structured**
2. **Unstructured**
3. **Semi-structured**
4. **Unstructured**
5. **Semi-structured**
6. **Structured**

---

## Exercise 2: Character Encoding
1. 6 bytes.
2. 6 bytes (ASCII range).
3. Universal support for all languages, backward compatibility with ASCII, and efficiency.
4. It will be replaced by a placeholder (like `?`) or cause an error, as ASCII doesn't support it.

---

## Exercise 3: Processing Unstructured Data (Logs)
1. `grep "403" access.log`
2. `awk '{print $1}' access.log`
3. `awk '{print $1}' access.log | sort | uniq -c`
4. `sed 's/GET/POST/g' access.log`

---

## Exercise 4: JSON, XML, and YAML
1. 
```json
{
  "sensor": {
    "id": "DHT11",
    "location": "Room 101",
    "readings": [
      { "timestamp": "2026-05-01T12:00:00", "value": 25.5 }
    ]
  }
}
```
2.
```yaml
sensor:
  id: DHT11
  location: Room 101
  readings:
    - timestamp: 2026-05-01T12:00:00
      value: 25.5
```
3. `jq '.sensor.location'`

---

## Exercise 5: CSV Parsing
1. Because the name contains a comma ("Bob, Smith"), which is the delimiter.
2. `awk -F, '{print $2, $3}' students.csv` (Note: `awk`'s simple split doesn't handle quotes perfectly; `csvkit` or Python is better for complex CSVs).
3. `awk -F, 'NR>1 {sum+=$3; count++} END {print sum/count}' students.csv`

---

## Exercise 6: Python and Pydantic
1.
```python
from pydantic import BaseModel, EmailStr, ValidationError
import json

class User(BaseModel):
    id: int
    name: str
    email: EmailStr

def validate_users(file_path):
    with open(file_path, 'r') as f:
        data = json.load(f)
    
    for item in data:
        try:
            user = User(**item)
            print(f"Valid: {user}")
        except ValidationError as e:
            print(f"Invalid entry: {item['name']} - {e}")
```
2. Pydantic will raise a `ValidationError` for that specific item.
