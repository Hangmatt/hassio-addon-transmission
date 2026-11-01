#!/usr/bin/with-contenv bashio
set -euo pipefail
# ==============================================================================
declare port
declare ingress_interface
declare ingress_port

ingress_port=$(bashio::app.ingress_port)
ingress_interface=$(bashio::app.ip_address)

if ! bashio::var.has_value "${ingress_port}"; then
    bashio::exit.nok 'Ingress is enabled but no ingress port was provided'
fi

if ! bashio::var.has_value "${ingress_interface}"; then
    bashio::exit.nok 'Ingress is enabled but no add-on IP address was provided'
fi

if [[ ! "${ingress_port}" =~ ^[0-9]+$ ]]; then
    bashio::exit.nok "Invalid ingress port: ${ingress_port}"
fi

if [[ ! "${ingress_interface}" =~ ^[0-9.]+$ ]]; then
    bashio::exit.nok "Invalid add-on IP address: ${ingress_interface}"
fi

sed -i "s|%%port%%|${ingress_port}|g; s|%%interface%%|${ingress_interface}|g" \
    /etc/nginx/servers/ingress.conf

if grep -q '%%\(port\|interface\)%%' /etc/nginx/servers/ingress.conf; then
    bashio::exit.nok 'Nginx ingress configuration still contains unresolved placeholders'
fi

nginx -t -q
