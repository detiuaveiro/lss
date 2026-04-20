#!/bin/bash

# Exercise 3: Working with CSV Data

# 1. View in table format
column -s, -t students.csv

# 2. Print names and grades
awk -F, '{print $2, $3}' students.csv

# 3. Find students from Aveiro
grep "Aveiro" students.csv

# 4. Calculate average grade (skipping header)
awk -F, 'NR > 1 {sum += $3; count++} END {if (count > 0) print "Average:", sum/count}' students.csv
