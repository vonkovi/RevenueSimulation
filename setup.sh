#!/usr/bin/env bash
set -e

# --- color definitions ---
reset="\033[0m"
blue="\033[34m"
cyan="\033[36m"
green="\033[32m"
yellow="\033[33m"

log_info() { echo -e "${blue}info:${reset} ${1,,}"; }
log_step() { echo -e "${cyan}step:${reset} ${1,,}"; }
log_success() { echo -e "${green}success:${reset} ${1,,}"; }
log_warn() { echo -e "${yellow}warn:${reset} ${1,,}"; }

# a. ensure requirements.txt exists
if [ ! -f requirements.txt ]; then
    log_warn "requirements.txt not found. creating one with agentsociety..."
    echo "agentsociety" > requirements.txt
    echo "grpcio" >> requirements.txt
    echo "grpcio-status" >> requirements.txt
fi

# b. ensure python 3.12 & venv
uv python install 3.12 > /dev/null
if [ ! -d .venv ]; then
    log_step "creating virtual environment with python 3.12..."
    uv venv --python 3.12
fi

# c. force install/sync
log_step "installing agentsociety and dependencies..."
uv pip install -r requirements.txt
log_step "applying compatibility fix for grpcio..."
uv pip install --upgrade --force-reinstall grpcio grpcio-status --quiet

# d. verify installation
if .venv/bin/python -c "import agentsociety" >/dev/null 2>&1; then
    log_success "agentsociety successfully installed in .venv."
else
    log_warn "installation failed. check your internet connection or arch mirrors."
    exit 1
fi

# e. final status check
if [[ "$VIRTUAL_ENV" == *"$(pwd)/.venv"* ]]; then
    log_success "setup complete. environment is active and ready."
else
    source .venv/bin/activate
    log_success "setup complete. activated 'source .venv/bin/activate'"
fi