#!/usr/bin/with-contenv bashio
set -euo pipefail
# ==============================================================================
# This files check if all user configuration requirements are met
# ==============================================================================

# Direct LAN access must never disable Transmission authentication.
if bashio::config.true 'direct_access' && ! bashio::config.true 'authentication_required'; then
    bashio::exit.nok 'Direct LAN access requires Transmission authentication'
fi

# Check authentication requirements, if enabled
if bashio::config.true 'authentication_required'; then
    if ! bashio::config.has_value 'username'; then
        bashio::exit.nok 'Transmission authentication is enabled, but no username was specified'
    fi

    if ! bashio::config.has_value 'password'; then
        bashio::exit.nok 'Transmission authentication is enabled, but no password was specified'
    fi
fi

# Check OpenVPN requirements, if enabled
if bashio::config.true 'openvpn_enabled'; then
    if ! bashio::config.has_value 'openvpn_username'; then
        bashio::exit.nok 'OpenVPN is enabled, but no username was specified'
    fi

    if ! bashio::config.has_value 'openvpn_password'; then
        bashio::exit.nok 'OpenVPN is enabled, but no password was specified'
    fi

    if ! bashio::config.has_value 'openvpn_config'; then
        bashio::exit.nok 'OpenVPN is enabled, but no openvpn_config was specified'
    fi

    openvpn_config=$(bashio::config 'openvpn_config')
    if [[ "${openvpn_config}" =~ \.\. ]]; then
        bashio::exit.nok "Invalid openvpn_config: path traversal ('..') is not allowed"
    fi

    config_name="${openvpn_config%.ovpn}"
    found=false
    for candidate in \
        "/config/${config_name}.ovpn" \
        "/config/openvpn/${config_name}.ovpn" \
        "/data/openvpn/${config_name}.ovpn"; do
        if bashio::fs.file_exists "${candidate}"; then
            found=true
            break
        fi
    done

    if [[ "${found}" = false ]]; then
        bashio::exit.nok "OpenVPN configuration file not found. Checked: /config/${config_name}.ovpn, /config/openvpn/${config_name}.ovpn, and /data/openvpn/${config_name}.ovpn"
    fi
fi
