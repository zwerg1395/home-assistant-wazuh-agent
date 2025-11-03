#!/command/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2034
set -e
# ==============================================================================
# Addon: wazuh-agent
# Starts wazuh-agent
# ==============================================================================

bashio::log.info "Service starting"
# Declare variables
declare managerip

# Retrieve settings
MANAGER_IP=$(bashio::config 'managerip')

# Export variables
export DATA_FOLDER=/data
export WAZUH_MANAGER=${MANAGER_IP}

sed -i "s|MANAGER_IP|$WAZUH_MANAGER|g" /var/ossec/etc/ossec.conf

bashio::log.info "Service starting"
## Run your program

bashio::log.info "WAZUH_MANAGER: ${WAZUH_MANAGER}"

bashio::log.info "Service starting"
cd /var/ossec/bin || bashio::exit.nok
./wazuh-control start