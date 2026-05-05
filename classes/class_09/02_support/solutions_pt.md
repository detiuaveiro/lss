# Soluções para os Exercícios da Aula 09

## Exercício 1: Identificar a Estrutura de Dados
1. **Estruturada**
2. **Não Estruturada**
3. **Semi-estruturada**
4. **Não Estruturada**
5. **Semi-estruturada**
6. **Estruturada**

---

## Exercício 2: Codificação de Caracteres
1. 6 bytes.
2. 6 bytes (intervalo ASCII).
3. Suporte universal para todas as línguas, retrocompatibilidade com ASCII e eficiência.
4. Será substituído por um marcador (ex: `?`) ou causará um erro, pois o ASCII não o suporta.

---

## Exercício 3: Processamento de Dados Não Estruturados (Logs)
1. `grep "403" access.log`
2. `awk '{print $1}' access.log`
3. `awk '{print $1}' access.log | sort | uniq -c`
4. `sed 's/GET/POST/g' access.log`

---

## Exercício 4: JSON, XML e YAML
1. 
```json
{
  "sensor": {
    "id": "DHT11",
    "location": "Sala 101",
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
  location: Sala 101
  readings:
    - timestamp: 2026-05-01T12:00:00
      value: 25.5
```
3. `jq '.sensor.location'`

---

## Exercício 5: Processamento de CSV
1. Porque o nome contém uma vírgula ("Bob, Smith"), que é o delimitador.
2. `awk -F, '{print $2, $3}' students.csv` (Nota: o split simples do `awk` não lida perfeitamente com aspas; `csvkit` ou Python são melhores para CSVs complexos).
3. `awk -F, 'NR>1 {sum+=$3; count++} END {print sum/count}' students.csv`

---

## Exercício 6: Python e Pydantic
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
2. O Pydantic lançará uma `ValidationError` para esse item específico.
