#!/bin/bash

# Lab Runner for Class 08: Advanced Communication, Performance and Security

set -e

# Ensure we are in the script's directory
cd "$(dirname "$0")"

log() {
    echo -e "\n\033[1;32m[LOG] $1\033[0m"
}

# 1. Setup Network
log "Creating lab-net network..."
docker network create --subnet=172.25.0.0/16 lab-net 2>/dev/null || echo "Network already exists."

# 2. Launch Infrastructure
log "Launching infrastructure with Docker Compose..."
docker compose up -d

log "Waiting for containers to initialize (15 seconds)..."
sleep 15

# Part 1: Performance & Monitoring
log "Exercise 1: Throughput Testing (iperf3)"
docker exec laptop iperf3 -c 172.25.0.30 -t 5

log "Exercise 2: Real-time Analysis (mtr)"
log "Running mtr for 5 cycles..."
docker exec laptop mtr -c 5 --report 172.25.0.10

# Part 2: Efficient Synchronization (rsync)
log "Exercise 3: Smart Backups"
log "Creating a 10MB project file on laptop..."
docker exec laptop dd if=/dev/urandom of=/project.pdf bs=1M count=10
log "Syncing to home-server (first time)..."
# Automatically test with sshpass to verify setup
docker exec laptop sshpass -p studentpass rsync -avz -e 'ssh -p 2222 -o StrictHostKeyChecking=no' /project.pdf student@172.25.0.10:/config/
log "Success: Automated sync verified."
echo "To run manually: docker exec -it laptop rsync -avz -e 'ssh -p 2222' /project.pdf student@172.25.0.10:/config/"

# Part 3: Bypassing Limitations (SSH)
log "Exercise 4 & 5: SSH Tunneling"
log "To test Local Port Forwarding, run on your HOST (connects to 2222 on localhost, then 5432 on target):"
echo "ssh -p 2222 -L 9000:172.25.0.40:5432 student@localhost"
log "To test Dynamic SOCKS Proxy, run on your HOST:"
echo "ssh -p 2222 -D 1080 student@localhost"

# Part 4: Advanced Reliability
log "Exercise 6: Load Balancing"
log "Testing uni-gateway (load balancer) connectivity to private-db..."
# Requesting secret.txt through the gateway
curl -s http://localhost:8081/secret.txt | grep "SENSITIVE" && echo "Success: Gateway is forwarding to Private DB."

log "Lab execution complete."
