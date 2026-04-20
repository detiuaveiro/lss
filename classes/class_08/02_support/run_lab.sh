#!/bin/bash

set -e

# Configuration
LAB_DIR="class08-restricted-lab"
COMPOSE_FILE="docker-compose.yml"

log() {
    echo "--- $(date '+%Y-%m-%d %H:%M:%S') - $1 ---"
}

check_dependencies() {
    log "Verifying System Dependencies"
    if ! command -v docker &> /dev/null; then
        echo "Critical Error: docker is not installed."
        exit 1
    fi
    if ! docker compose version &> /dev/null; then
        echo "Critical Error: docker compose is not installed."
        exit 1
    fi
}

setup_environment() {
    log "Preparing Local Workspace: $LAB_DIR"
    mkdir -p "$LAB_DIR"
    cp docker-compose.yml nginx.conf "$LAB_DIR/"
    cp -r prod-server backup-server "$LAB_DIR/"
    cd "$LAB_DIR"
}

deploy_infrastructure() {
    log "Deploying Simulated Restricted Network (Docker)"
    # Ensure network is clean
    docker compose down -v --remove-orphans || true
    # Start
    docker compose up -d --build
    log "Waiting for containers to initialize..."
    sleep 5
}

run_demos() {
    log "Demonstration 1: Network Throughput Analysis"
    log "Measuring capacity between University Laptop and Internet Target"
    docker exec laptop iperf3 -c 172.25.0.30 -t 5

    log "Demonstration 2: Efficient Synchronization"
    log "Scenario: Syncing a project file to Home Server"
    docker exec laptop sh -c "dd if=/dev/urandom of=/data/thesis_v1.pdf bs=1M count=5"
    log "Communicating deltas to 172.25.0.10"
    docker exec laptop rsync -avz /data/thesis_v1.pdf student@172.25.0.10:/config/backup/

    log "Demonstration 3: Bridging Restricted Port (Info)"
    log "To access the Private DB (blocked on eduroam), run this on your REAL HOST:"
    log "ssh -L 9000:172.25.0.40:5432 student@localhost -p 2222"

    log "Demonstration 4: Load Balancing Gateway"
    log "Validating University Gateway response"
    curl -s http://localhost:8081 | grep "Server" || echo "Note: Manually configure NGINX backends for full demo."
}

conclusion() {
    echo ""
    log "Automation Complete"
    echo "The lab environment is now active."
    echo "Current Nodes: laptop (University), home-server (Private), private-db (Isolated), uni-gateway (Proxy)."
    echo "To terminate the environment: cd $LAB_DIR && docker compose down"
}

# Main Lifecycle
check_dependencies
setup_environment
deploy_infrastructure
run_demos
conclusion
