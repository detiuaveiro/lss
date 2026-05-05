import json

# 1. Define student dictionary
student = {
    "name": "Mário Antunes",
    "id": 123456,
    "courses": ["LSS", "Bayesian Agents", "Machine Learning"],
    "address": {
        "street": "University of Aveiro",
        "city": "Aveiro",
        "zip": "3810-193"
    }
}

# 2. Save to student.json
with open("student.json", "w") as f:
    json.dump(student, f, indent=4)

# 3. Read back and print name
with open("student.json", "r") as f:
    data = json.load(f)
    print(f"Student Name: {data['name']}")
