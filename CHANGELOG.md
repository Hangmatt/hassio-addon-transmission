# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

# <<<<<<< Updated upstream

### Added

- Multi-path OpenVPN configuration support (`/config/`, `/config/openvpn/`, and `/data/openvpn/`)
- Strict directory traversal validation on OpenVPN config names
- Restrictive file permissions (0600) on OpenVPN credentials

### Changed

- Migrated add-on folder mapping from legacy `config:rw` to `addon_config:rw`
- Bumped Community Addons base image to 21.0.10 in Dockerfile and build.json
- Rebranded repository metadata, documentation, and Docker labels to Hangmatt fork

### Fixed

- Fixed S6-overlay v3 PID 1 conflict by adding `"init": false` to config.json
- Fixed service finish handlers by migrating from `s6-svscanctl` to `/run/s6/basedir/bin/halt`
- # Ensured executable permissions on all service run and finish scripts
  > > > > > > > Stashed changes
- Modernize to Home Assistant addon_config mapping and add support for /config/, /config/openvpn/, and /data/openvpn/
- Bump Community Addons base image to 21.0.10 in Dockerfile and build.json
- Set restrictive file permissions (0600) on OpenVPN credentials
- Modernize to Home Assistant addon_config mapping and add support for /config/, /config/openvpn/, and /data/openvpn/
- Bump Community Addons base image to 21.0.10 in Dockerfile and build.json
- Set restrictive file permissions (0600) on OpenVPN credentials
- Add images
- Install instructions
- Provide addon as repository
- Add documentation to embed Transmission in hass
  <<<<<<< Updated upstream
  =======
  > > > > > > > 130677a (Rebrand to Hangmatt fork, modernize addon_config, and bump base image)
  > > > > > > > Stashed changes

## [1.2.0] - 2018-08-24

### Added

- Parameters requirements

### Changed

- Refactoring

## [1.1.0] - 2018-08-24

### Added

- OpenVPN support

## [1.0.0] - 2018-08-23

### Added

- Working transmission client
