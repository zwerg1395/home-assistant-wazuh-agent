# Home Assistant Add-on: Wazuh Agent (fork)

_Add-on to add a wazuh-agent to Home Assistant._ This fork tracks the latest Wazuh Agent during image build and currently supports `amd64` only. Upstream: `Akrhin/home-assistant-wazuh-agent`.

[![Donate][donation-badge]](https://www.buymeacoffee.com/Akrhin/home-assistant-wazuh-agent)
![Supports amd64 Architecture][amd64-shield]

What is sent to Wazuh by default?

- By default, the agent inside this add-on sends standard Wazuh modules data from within the container (syscollector, integrity monitoring, and logcollector for files available inside the container).
- Home Assistant core logs are NOT forwarded by default because `/config` is not mounted into the add-on.

How to forward Home Assistant logs:

1. Mount `/config` into the add-on (e.g., add `map: - config:ro` in `config.yaml`).
2. Add a `localfile` entry into `/var/ossec/etc/ossec.conf` pointing to `/config/home-assistant.log`:

    ```xml
   <localfile>
     <log_format>syslog</log_format>
     <location>/config/home-assistant.log</location>
   </localfile>
    ```

3. Restart the add-on.

[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[donation-badge]: https://img.shields.io/badge/donate-buymeacoffee-yellow.svg
