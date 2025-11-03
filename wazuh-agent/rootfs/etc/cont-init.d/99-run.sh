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
declare agentname

# Retrieve settings
MANAGER_IP=$(bashio::config 'managerip')
AGENT_NAME=$(bashio::config 'agentname' 'ha-wazuh')

# Export variables
export DATA_FOLDER=/data
export WAZUH_MANAGER=${MANAGER_IP}
export WAZUH_AGENT_NAME=${AGENT_NAME}

# Update manager IP in config
sed -i "s|MANAGER_IP|$WAZUH_MANAGER|g" /var/ossec/etc/ossec.conf

# Set agent name in config
# First, try to replace existing agent_name
if grep -q "<agent_name>" /var/ossec/etc/ossec.conf; then
    sed -i "s|<agent_name>.*</agent_name>|<agent_name>$WAZUH_AGENT_NAME</agent_name>|g" /var/ossec/etc/ossec.conf
else
    # Add agent_name inside <client> section if not present
    sed -i "/<client>/a\    <agent_name>$WAZUH_AGENT_NAME</agent_name>" /var/ossec/etc/ossec.conf
fi

bashio::log.info "Agent name set to: ${WAZUH_AGENT_NAME}"

bashio::log.info "Service starting"
## Run your program

bashio::log.info "WAZUH_MANAGER: ${WAZUH_MANAGER}"

bashio::log.info "Service starting"
cd /var/ossec/bin || bashio::exit.nok
./wazuh-control start