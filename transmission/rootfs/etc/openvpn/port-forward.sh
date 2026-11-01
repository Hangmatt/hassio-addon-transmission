#!/usr/bin/with-contenv bashio
set -u

GATEWAY="10.2.0.1"
RPC_AUTH=''
if bashio::config.true 'authentication_required'; then
    RPC_AUTH="$(bashio::config 'username'):$(bashio::config 'password')"
fi
bashio::net.wait_for 9091
while true; do
    bashio::log.info 'Requesting Proton VPN NAT-PMP port'
    output=$(natpmpc -a 1 0 udp 60 -g "${GATEWAY}" 2>&1) || {
        bashio::log.error "NAT-PMP UDP request failed: ${output}"
        exit 1
    }
    tcp_output=$(natpmpc -a 1 0 tcp 60 -g "${GATEWAY}" 2>&1) || {
        bashio::log.error "NAT-PMP TCP request failed: ${tcp_output}"
        exit 1
    }

    port=$(printf '%s\n%s\n' "${output}" "${tcp_output}" | sed -nE 's/.*Mapped public port ([0-9]+).*/\1/p' | head -n 1)
    if [[ -n "${port}" ]]; then
        auth_args=()
        if [[ -n "${RPC_AUTH}" ]]; then
            auth_args=(-u "${RPC_AUTH}")
        fi
        session_id=$(curl --silent --show-error --dump-header - \
            "${auth_args[@]}" \
            http://127.0.0.1:9091/transmission/rpc \
            -o /dev/null | awk 'tolower($1) == "x-transmission-session-id:" {print $2}' | tr -d '\r')
        if [[ -n "${session_id}" ]]; then
            curl --silent --show-error --fail \
                "${auth_args[@]}" \
                -H "X-Transmission-Session-Id: ${session_id}" \
                -H 'Content-Type: application/json' \
                --data "{\"method\":\"session-set\",\"arguments\":{\"peer-port\":${port}}}" \
                http://127.0.0.1:9091/transmission/rpc >/dev/null
        else
            bashio::log.warning 'Could not obtain Transmission RPC session ID'
        fi
        bashio::log.info "Proton VPN forwarded peer port: ${port}"
    else
        bashio::log.warning 'NAT-PMP succeeded but no public port was found in output'
    fi
    sleep 45
done
