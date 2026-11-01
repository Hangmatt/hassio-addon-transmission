# Transmission add-on hardening plan

## Goal

Make the Transmission Home Assistant add-on reliable across VPN connection
loss/reconnects and reduce unnecessary privileges and host exposure without
breaking ingress.

## Current bounded changes

- Use the current Bashio add-on namespace for ingress configuration.
- Make the add-on manifest use a boolean ingress flag and a semantic version.
- Remove committed credential values and disable credential-dependent defaults.

## Phase 1: OpenVPN lifecycle reliability

Status: implemented; container build and hook/Nginx smoke tests pass. A full
Home Assistant Supervisor run with a real VPN provider remains environment
dependent.

1. Confirm the base image's OpenVPN/s6 lifecycle contract and available hook
   scripts instead of patching `/etc/openvpn/up.sh` at runtime.
2. Ensure exactly one Transmission process is supervised.
3. Define behavior for VPN startup failure, disconnect, reconnect, and shutdown.
4. Keep Transmission bound to the VPN interface when connected, while avoiding
   stale interface addresses after reconnect.
5. Add startup and reconnect tests using a fake OpenVPN hook or container test
   harness.

Implementation notes:

- OpenVPN and Transmission are separate s6 services.
- OpenVPN uses dedicated up/down hooks and no longer patches base-image files.
- Transmission starts only after a VPN address is published, stops when that
  state disappears, and restarts when the address changes.
- VPN-disabled mode keeps the OpenVPN service idle and starts Transmission
  directly.

## Phase 2: Security and operational hardening

Status: implemented; image build, Nginx smoke checks, Git-ignore checks, a
real OpenVPN provider handshake, and an authenticated published-port test pass.
A test from a separate physical LAN device still requires installing the app
on Home Assistant or reproducing its network.

1. Remove unnecessary `config`, `share`, and `media` write access where the
   selected download paths do not require it.
2. Make direct RPC exposure opt-in or restrict it to authenticated access.
3. Ensure the app is reachable from the local network: bind the intended
   services to the correct container interfaces, preserve the published LAN
   ports, and verify access from another device on the same network.
4. Add explicit validation for Nginx configuration and required Bashio values.
5. Add a container health/readiness check covering Transmission, Nginx, and VPN
   state where applicable.
6. Pin or regularly verify base-image and package versions, then document the
   supported Home Assistant/add-on versions and upgrade procedure.

## Verification gates

- Build succeeds for the supported `aarch64` and `amd64` architectures.
- Ingress loads the UI and RPC calls succeed.
- VPN-disabled startup succeeds with empty credential fields.
- VPN-enabled startup rejects missing credentials clearly.
- VPN reconnect does not create duplicate daemons or leave stale bindings.
- Direct access is disabled by default and requires authentication when enabled.
- Direct LAN access and filesystem mappings match the documented threat model.
