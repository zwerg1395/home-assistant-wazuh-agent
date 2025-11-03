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

# Set agent name in config within <client><enrollment>
# 1) If <enrollment> exists, replace or add <agent_name> inside the block
if grep -q "<enrollment>" /var/ossec/etc/ossec.conf; then
    # Try to replace existing agent_name inside enrollment block
    sed -i '/<enrollment>/,/<\/enrollment>/ s|<agent_name>.*</agent_name>|<agent_name>'"$WAZUH_AGENT_NAME"'</agent_name>|g' /var/ossec/etc/ossec.conf

    # If still no agent_name in the enrollment block, insert it after <enrollment>
    if ! awk '/<enrollment>/{flag=1} /<\/enrollment>/{flag=0} flag && /<agent_name>/{found=1} END{exit !found}' /var/ossec/etc/ossec.conf; then
        sed -i '/<enrollment>/,/<\/enrollment>/{ /<enrollment>/ a\
      <agent_name>'"$WAZUH_AGENT_NAME"'</agent_name>
        }' /var/ossec/etc/ossec.conf
    fi
else
    # 2) No <enrollment> block: create a minimal one before </client>
    sed -i '/<\/client>/ i\
    <enrollment>\
      <enabled>yes<\/enabled>\
      <agent_name>'"$WAZUH_AGENT_NAME"'<\/agent_name>\
    <\/enrollment>' /var/ossec/etc/ossec.conf
fi

bashio::log.info "Agent name set to: ${WAZUH_AGENT_NAME}"

bashio::log.info "Service starting"
## Run your program

bashio::log.info "WAZUH_MANAGER: ${WAZUH_MANAGER}"

bashio::log.info "Service starting"
cd /var/ossec/bin || bashio::exit.nok
./wazuh-control start