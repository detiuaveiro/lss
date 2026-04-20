#!/bin/bash

# Exercise 2: Processing JSON with jq

# 1. Prettify
jq '.' data.json

# 2. Extract first element
jq '.[0]' data.json

# 3. Extract names
jq '.[].name' data.json

# 4. Filter active users
jq '.[] | select(.active == true)' data.json

# 5. Filter active admins
jq '.[] | select(.role == "admin" and .active == true)' data.json
