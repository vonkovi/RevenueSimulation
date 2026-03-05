#!/usr/bin/env bash
set -e

# --- colors ---
blue="\033[34m"
green="\033[32m"
reset="\033[0m"

log() { echo -e "${blue}info:${reset} ${1,,}"; }
success() { echo -e "${green}success:${reset} ${1,,}"; }

# a. check if image exists
if [ -z "$(docker images -q revenuesimulation-simulation:latest 2> /dev/null)" ]; then
    log "building image..."
    docker compose build
fi

# b. launch ui with the gateway bridge
log "launching ui on http://localhost:8080"
success "ready! press ctrl+c to stop."
docker compose run --rm --service-ports simulation \
    "agentsociety ui & \
     sleep 3 && \
     socat TCP-LISTEN:9000,fork,reuseaddr TCP:127.0.0.1:8080"