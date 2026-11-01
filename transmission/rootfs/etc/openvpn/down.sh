#!/usr/bin/with-contenv bashio

if bashio::config.true 'kill_switch'; then
    bashio::log.warning 'OpenVPN disconnected; stopping Transmission'
    pkill -TERM -x transmission-daemon || true
else
    bashio::log.warning 'Kill switch disabled: leaving Transmission running during VPN reconnect'
fi
pkill -TERM -f '/etc/openvpn/port-forward.sh' || true

if bashio::config.true 'kill_switch'; then
    bashio::log.warning 'Kill switch enabled: Transmission remains stopped until VPN reconnects'
fi
