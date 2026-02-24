# Exercise 2: Building a Custom Web Server Image
# This Dockerfile creates a self-contained NGINX image
# with the website files baked in.

# Use the lightweight Alpine-based NGINX image as the base
FROM nginx:alpine

# Copy the local website files into the NGINX default web root.
# These files become part of the image and do not change at runtime.
COPY ./my-website /usr/share/nginx/html
