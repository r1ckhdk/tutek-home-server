#!/bin/bash

set -euo pipefail

USERNAME="woodpecker"
SSH_DIR="/home/${USERNAME}/.ssh"
KEY_NAME="${USERNAME}_id_ed25519"
KEY_PATH="${SSH_DIR}/${KEY_NAME}"
PUB_KEY_PATH="${KEY_PATH}.pub"
SUDO_FILE="/etc/sudoers.d/${USERNAME}"
AUTHORIZED_KEYS="${SSH_DIR}/authorized_keys"

if ! id "$USERNAME" &>/dev/null; then
    echo "Creating user $USERNAME..."
    useradd -m $USERNAME
else
    echo "User ${USERNAME} already exists." 
    echo "Aborting script..."
    exit 0
fi

if [[ ! -d "$SSH_DIR" ]]; then
    echo "Setting up .ssh directory for $USERNAME"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    chown "${USERNAME}:${USERNAME}" "$SSH_DIR"
else
    echo ".ssh directory already exists. Checking permissions..."
    [[ "$(stat -c "%a" "$SSH_DIR")" != "700" ]] && chmod 700 "$SSH_DIR"
    [[ "$(stat -c "%U:%G" "$SSH_DIR")" != "${USERNAME}:${USERNAME}" ]] && chown "${USERNAME}:${USERNAME}" "$SSH_DIR"
fi


if [[ ! -f "$KEY_PATH" ]]; then
    echo "Generating SSH key for ${USERNAME}..."
    ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -C "${USERNAME}@$(hostname)" &>/dev/null
    chown "${USERNAME}:${USERNAME}" "$KEY_PATH" "$PUB_KEY_PATH"
    chmod 600 "$KEY_PATH"
    chmod 644 "$PUB_KEY_PATH"
else
    echo "SSH key already exists in ${KEY_PATH}, it won't be generated again"
fi


if [[ ! -f "$AUTHORIZED_KEYS" ]] || ! grep -q -F "$(cat "$PUB_KEY_PATH")" "$AUTHORIZED_KEYS"; then
    echo "Adding public key to authorized keys..."
    cat "$PUB_KEY_PATH" >> "$AUTHORIZED_KEYS"
    chown "${USERNAME}:${USERNAME}" "$AUTHORIZED_KEYS"
    chmod 600 "$AUTHORIZED_KEYS"
else
    echo "Public key already present at authorized keys"
fi


if [[ ! -f "$SUDO_FILE" ]]; then
    echo "Configuring sudoers file for ${USERNAME}..."
    echo "${USERNAME} ALL=(ALL) NOPASSWD: /usr/bin/apt-get, /usr/sbin/reboot" > "$SUDO_FILE"
    chmod 440 "$SUDO_FILE"
else
    echo "Sudoers file already configured"
fi

echo "${USERNAME}'s public key (copy it to your CI pipeline):"
cat "$PUB_KEY_PATH"

echo "Setup ${USERNAME} ssh finished succesfully!"
