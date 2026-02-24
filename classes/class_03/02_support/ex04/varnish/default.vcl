vcl 4.1;

# Define the backend server that Varnish will fetch content from.
# The hostname 'nginx' matches the service name in compose.yml.
# Docker Compose automatically resolves this via its internal DNS.
backend default {
    .host = "nginx";
    .port = "80";
}
