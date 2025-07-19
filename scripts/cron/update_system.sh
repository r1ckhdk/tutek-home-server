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

log "INFO" "Executing apt update..."
apt update >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt update"
    exit 1
}

log "INFO" "Executing apt upgrade..."
apt upgrade -y >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt upgrade"
    exit 1
}

log "INFO" "Executing apt autoclean..."
apt autoclean >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt autoclean"
    exit 1
}

log "INFO" "Executing apt autoremove..."
apt autoremove -y >> "${LOG_FILE}" 2>&1 || {
    log "ERROR" "Failure when executing apt autoremove"
    exit 1
}

if [ -f /var/run/reboot-required ]; then
    log "WARN" "System reboot required"
    echo "Reboot required after upgrade" >> "${LOG_FILE}"
fi

log "INFO" "System update finished succesfully!"
exit 0