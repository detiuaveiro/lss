import csv
import json
import yaml

def main():
    students = []
    
    # Read CSV
    with open('students.csv', mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Convert grade to int
            row['grade'] = int(row['grade'])
            students.append(row)
            
    # Save to JSON
    with open('students.json', mode='w', encoding='utf-8') as f:
        json.dump(students, f, indent=2)
        print("Saved to students.json")
        
    # Save to YAML
    with open('students.yaml', mode='w', encoding='utf-8') as f:
        yaml.dump(students, f, default_flow_style=False)
        print("Saved to students.yaml")

if __name__ == "__main__":
    main()
