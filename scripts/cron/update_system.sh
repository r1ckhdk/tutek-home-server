#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

LOG_DIR="/var/log/system-maintenance"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/update_${TIMESTAMP}.log"

log() {
    local level=$1
    local message=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" | tee -a "${LOG_FILE}"
}

mkdir -p "${LOG_DIR}"

log "INFO" "Starting system update..."

log "INFO" "Executing apt-get update..."
apt-get update >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt-get update"
    exit 1
}

log "INFO" "Executing apt-get upgrade..."
apt-get upgrade -y >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt-get upgrade"
    exit 1
}

log "INFO" "Executing apt-get autoclean..."
apt-get autoclean >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt-get autoclean"
    exit 1
}

log "INFO" "Executing apt-get autoremove..."
apt-get autoremove -y >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt-get autoremove"
    exit 1
}

if [ -f /var/run/reboot-required ]; then
    log "WARN" "System reboot required"
    echo "Reboot required after upgrade" >> "${LOG_FILE}"
fi

log "INFO" "System update finished succesfully!"
exit 0