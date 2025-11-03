FROM ghcr.io/home-assistant/amd64-base-ubuntu:latest

SHELL ["/bin/bash", "-c"]

# Default ENV
ENV \
    LANG="C.UTF-8" \
    DEBIAN_FRONTEND="noninteractive" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_SERVICES_READYTIME=50

COPY rootfs/ /

# Install required packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        wget \
        jq \
        vim \
        yamllint \
    && rm -rf /var/lib/apt/lists/*

# Normalize script line endings and ensure executable permissions
RUN find /etc/cont-init.d -type f -name "*.sh" -exec sed -i 's/\r$//' {} + \
    && chmod 0755 /etc/cont-init.d/*.sh

# Install latest Wazuh Agent from official repository
RUN apt-get update \
    && install -d -m 0755 /usr/share/keyrings \
    && curl -fsSL https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor -o /usr/share/keyrings/wazuh.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends wazuh-agent \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

