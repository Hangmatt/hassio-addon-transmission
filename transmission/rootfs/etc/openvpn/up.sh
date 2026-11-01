#!/usr/bin/with-contenv bashio
set -euo pipefail

VPN_ADDRESS="${ifconfig_local:-${4:-}}"
if [[ -z "${VPN_ADDRESS}" ]]; then
    bashio::log.error 'OpenVPN did not provide a tunnel address; refusing to start Transmission'
    exit 1
fi

bashio::log.info "OpenVPN connected with tunnel address ${VPN_ADDRESS}"
/etc/openvpn/up-transmission.sh "${VPN_ADDRESS}"

if bashio::config.true 'port_forwarding'; then
    /etc/openvpn/port-forward.sh &
fi
