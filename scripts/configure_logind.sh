#!/bin/bash


# Check if script is being run as root
if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root"
	exit 1
fi


CONFIG_FILE="/etc/systemd/logind.conf"

echo "Configuring logind to ignore closed lid"


# Backup logind.conf file
if [ ! -f "${CONFIG_FILE}.bkp" ]; then
	cp "${CONFIG_FILE}" "${CONFIG_FILE}.bkp"
	echo "Original file backup saved in ${CONFIG_FILE}.bkp"
fi

# Change configurations on HandleLid
sudo sed -i '/^#\?HandleLidSwitch=/c\HandleLidSwitch=ignore' $CONFIG_FILE && \
sudo sed -i '/^#\?HandleLidSwitchExternalPower=/c\HandleLidSwitchExternalPower=ignore' $CONFIG_FILE && \
sudo sed -i '/^#\?HandleLidSwitchDocked=/c\HandleLidSwitchDocked=ignore' $CONFIG_FILE && \
sudo sed -i '/^#\?LidSwitchIgnoreInhibited=/c\LidSwitchIgnoreInhibited=no' $CONFIG_FILE && \
sudo sed -i '/^#\?HandleSuspendKey=/c\HandleSuspendKey=ignore' $CONFIG_FILE && \
sudo sed -i '/^#\?IdleAction=/c\IdleAction=ignore' $CONFIG_FILE


echo "Configuration changes applied on ${CONFIG_FILE}"

echo "Restarting service systemd-logind..."
sudo systemctl restart systemd-logind

echo "Configuration finished. Now the system ignores lid closing"
