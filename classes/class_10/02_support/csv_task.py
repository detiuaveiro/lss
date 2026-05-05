import csv

# Create grades.csv for testing
data = [
    ["Student", "Subject", "Grade"],
    ["Alice", "Math", 18],
    ["Bob", "Math", 15],
    ["Charlie", "Physics", 12],
    ["David", "Physics", 14],
    ["Eve", "Math", 17]
]

with open("grades.csv", "w", newline='') as f:
    writer = csv.writer(f)
    writer.writerows(data)

# Read and calculate average
grades = []
with open("grades.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        grades.append(float(row['Grade']))

average = sum(grades) / len(grades)
print(f"Average Grade: {average:.2f}")
