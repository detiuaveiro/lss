#!/bin/bash

# Exercise 1: Processing Unstructured Data (Logs)

# 1. Find all entries with a 403 status code
grep "403" access.log

# 2. Print only the IP addresses (first column)
awk '{print $1}' access.log

# 3. Count how many requests each IP address made
awk '{print $1}' access.log | sort | uniq -c

# 4. Replace GET with POST
sed 's/GET/POST/g' access.log
