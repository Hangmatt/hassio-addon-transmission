#!/usr/bin/with-contenv bashio
# ==============================================================================
# Publishes the current VPN address for the supervised Transmission service.
# OpenVPN passes the tunnel interface as $1 and the local VPN address as $3.
# ===============================================================================
state_dir=/run/transmission
state_file=${state_dir}/vpn-ip

mkdir -p "${state_dir}"
tmp_file=$(mktemp "${state_file}.XXXXXX")
printf '%s\n' "${3}" > "${tmp_file}"
mv "${tmp_file}" "${state_file}"

bashio::log.info "VPN is up on ${1} with address ${3}"
