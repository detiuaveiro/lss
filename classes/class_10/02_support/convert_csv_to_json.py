import csv
import json

# Assuming grades.csv exists
rows = []
with open("grades.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        # Convert grade to float
        row['Grade'] = float(row['Grade'])
        rows.append(row)

with open("grades.json", "w") as f:
    json.dump(rows, f, indent=4)

print("Successfully converted grades.csv to grades.json")
