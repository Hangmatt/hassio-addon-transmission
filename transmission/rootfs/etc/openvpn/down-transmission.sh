#!/usr/bin/with-contenv bashio
# ==============================================================================
# Removes the VPN state so the supervised Transmission service stops promptly.
# ===============================================================================
rm -f /run/transmission/vpn-ip
bashio::log.info "VPN is down; Transmission will stop"
