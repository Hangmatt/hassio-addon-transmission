# Transmission Home Assistant add-on

Transmission torrent client with optional Proton VPN OpenVPN protection, Home Assistant ingress, and local web access.

## Installation

1. Open **Settings → Add-ons → Add-on store → ⋮ → Repositories**.
2. Add `https://github.com/Hangmatt/hassio-addon-transmission`.
3. Install **Transmission**, configure it, then start it.
4. Open the add-on **Web UI** or show it in the Home Assistant sidebar.

Home Assistant ingress is enabled on internal port `8099`. Transmission web access is also exposed on host port `9091`; use `http://HOME_ASSISTANT_HOST:9091/transmission/web/` from the local network. Do not expose port 9091 directly to the internet. The add-on does not publish a fixed peer port.

## Proton VPN setup

Port forwarding requires a paid Proton VPN plan and a Proton P2P server. Download a Linux OpenVPN `.ovpn` profile for a P2P server. Put it in the add-on configuration directory, mounted as `/config`, or in `/config/openvpn/`. Set `openvpn_config` to its filename, with or without `.ovpn`.

Use Proton OpenVPN credentials, not normal Proton account credentials. If `port_forwarding` is enabled, append `+pmp` to the OpenVPN username (for example, `username+pmp`). Proton assigns a different public port after reconnecting; the add-on refreshes the NAT-PMP lease, verifies it, and updates Transmission automatically. That assigned port is authoritative for TCP and UDP; HA host mappings do not control Proton ingress. Disable Transmission router UPnP/NAT-PMP mapping because Proton supplies the mapping.

Example configuration:

```yaml
openvpn_enabled: true
openvpn_config: nl-free-123.protonvpn.udp.ovpn
openvpn_username: your_openvpn_username+pmp
openvpn_password: your_openvpn_password
port_forwarding: true
kill_switch: true
authentication_required: true
username: transmission
password: choose-a-strong-password
```

## Options

- `openvpn_enabled`: Start Transmission only after the OpenVPN tunnel is up.
- `kill_switch`: Stop Transmission when the tunnel goes down. Enabled by default.
- `port_forwarding`: Request and renew Proton NAT-PMP TCP/UDP peer port.
- `download_dir` and `incomplete_dir`: Must start with `/media` or `/share`.
- `authentication_required`, `username`, `password`: Protect the Transmission RPC/web client. Authentication is enabled by default.

Restart the add-on after changing options. Check **Settings → Add-ons → Transmission → Log**. Successful VPN startup logs the tunnel address; successful forwarding logs the assigned peer port.

## Troubleshooting

If VPN startup fails, verify the profile is a Proton P2P profile and credentials are OpenVPN credentials. If NAT-PMP fails, verify the username contains `+pmp` and the server supports port forwarding. If the tunnel drops, the kill switch intentionally stops Transmission until reconnect. If ingress works but port 9091 does not, verify the host port is free and the add-on port is exposed.

## Security

Store credentials in add-on options or Home Assistant secrets; never commit them or the `.ovpn` file. Port forwarding exposes Transmission's peer port through Proton, so keep RPC authentication enabled and expose port 9091 only to trusted local networks.

## License

MIT License. See `LICENSE.md`.
