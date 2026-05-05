---
title: Representation and Storage of Digital Information
---

# Exercises

## Exercise 1: Identifying Data Structure

For each of the following data sources, classify them as **Structured**, **Semi-structured**, or **Unstructured**:

1.  A relational database table containing student grades.
2.  A collection of MP3 files from a podcast.
3.  A `config.yaml` file for a web server.
4.  A scanned PDF of a handwritten letter.
5.  A JSON response from a weather API.
6.  An Excel spreadsheet containing a list of products.

---

## Exercise 2: Character Encoding

1.  How many bytes does the string "Hello!" take in ASCII?
2.  How many bytes does the string "Hello!" take in UTF-8?
3.  Why is UTF-8 preferred over ASCII for modern applications?
4.  What happens if you try to save the character "ç" in a file encoded as pure ASCII?

---

## Exercise 3: Processing Unstructured Data (Logs)

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

1.  Use `grep` to find all entries with a `403` status code.
2.  Use `awk` to print only the IP addresses (the first column).
3.  Combine `awk`, `sort`, and `uniq -c` to count how many requests each IP address made.
4.  Use `sed` to replace all occurrences of `GET` with `POST` in the output.

---

## Exercise 4: JSON, XML, and YAML

1.  Convert the following XML snippet into a valid JSON object:
    ```xml
    <sensor id="DHT11">
        <location>Room 101</location>
        <readings>
            <reading timestamp="2026-05-01T12:00:00">25.5</reading>
        </readings>
    </sensor>
    ```
2.  Represent the same information in YAML format.
3.  Use `jq` syntax to extract the `location` from your JSON object.

---

## Exercise 5: CSV Parsing

You have a CSV file `students.csv` with the following content:
```csv
id,name,grade,city
1,Alice,18,Aveiro
2,"Bob, Smith",14,Porto
3,Charlie,16,Aveiro
```

1.  In row 2, why is the name field enclosed in double quotes?
2.  Use `awk` (with `-F,`) to print only the names and grades.
3.  Calculate the average grade using `awk`.

---

## Exercise 6: Python and Pydantic

1.  Write a Python script that reads a JSON file containing a list of users and validates them using a Pydantic model with `id` (int), `name` (str), and `email` (EmailStr).
2.  What happens if one of the emails in the JSON is invalid?
