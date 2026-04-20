---
title: Representation and Communication of Digital Information I
---

# Exercises

## Exercise 1: Processing Unstructured Data (Logs)

In this exercise, you will use Unix tools to extract information from a system log.
Assume you have a file named `access.log` with the following content:
```text
192.168.1.1 - - [20/Apr/2026:10:00:01] "GET /index.html" 200
192.168.1.5 - - [20/Apr/2026:10:00:05] "GET /images/logo.png" 200
192.168.1.1 - - [20/Apr/2026:10:00:10] "GET /contact.html" 200
192.168.1.10 - - [20/Apr/2026:10:00:15] "GET /admin" 403
192.168.1.1 - - [20/Apr/2026:10:00:20] "GET /index.html" 200
192.168.1.5 - - [20/Apr/2026:10:00:25] "GET /about.html" 200
```

1.  Use `grep` to find all entries with a `403` (Forbidden) status code.
2.  Use `awk` to print only the IP addresses (the first column).
3.  Combine `awk`, `sort`, and `uniq` to count how many requests each IP address made.
4.  Use `sed` to replace all occurrences of `GET` with `POST` in the output.

-----

## Exercise 2: Processing JSON with `jq`

`jq` is a powerful tool for slicing, dicing, and transforming JSON data.
Create a file named `data.json` with the following content:
```json
[
  {"id": 1, "name": "Alice", "role": "admin", "active": true},
  {"id": 2, "name": "Bob", "role": "user", "active": false},
  {"id": 3, "name": "Charlie", "role": "user", "active": true},
  {"id": 4, "name": "David", "role": "admin", "active": true}
]
```

1.  Use `jq` to prettify the JSON output.
2.  Extract only the first element of the array.
3.  Extract the `name` of all users.
4.  Filter the users to show only those who are `active`.
5.  Filter the users to show only those who have the `admin` role and are `active`.

-----

## Exercise 3: Working with CSV Data

CSV is the standard for tabular data. Create a file `students.csv`:
```csv
id,name,grade,city
1,Alice,18,Aveiro
2,Bob,14,Porto
3,Charlie,16,Aveiro
4,David,10,Coimbra
```

1.  Use `column -s, -t students.csv` to view the CSV in a pretty table format.
2.  Use `awk` (with `-F,`) to print only the names and grades of the students.
3.  Use `grep` to find students from `Aveiro`.
4.  Calculate the average grade using a combination of `awk` and arithmetic.

-----

## Exercise 4: Python Serialization

In this exercise, you will write a Python script to convert data between formats.

1.  Create a Python script `convert.py` that:
    *   Reads the `students.csv` file created in Exercise 3.
    *   Converts the data into a list of dictionaries.
    *   Saves the data into a new file named `students.json`.
2.  Add functionality to the script to also save the data as a `YAML` file (requires `PyYAML`).

-----

## Exercise 5: Formatting and Interoperability

1.  Look at the following YAML snippet:
    ```yaml
    server:
      host: 127.0.0.1
      port: 8080
      debug: true
      endpoints:
        - /api/v1
        - /api/v2
    ```
2.  Try to represent the same information in JSON format.
3.  Discuss: Which format is easier to read? Which one is easier to write? Which one would you use for a web API?
