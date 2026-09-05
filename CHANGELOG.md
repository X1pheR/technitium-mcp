# Changelog

## [Unreleased]

## [0.0.1-x1pher.1] - 2026-09-05

### Added
- First X1pheR distribution of `Slyke/mcp-technitium-dns`, pinned to upstream commit `0b8f0478f4e759b17fe5d1410a72659fb3f61bfb`.
- Hardened non-root container packaging with a digest-pinned Node base image and runtime package-manager removal.
- Reproducible verification for upstream parity, tests, dependency audit, security scans, container hardening, and MCP tool-contract parity.

### Security
- Refreshed only the upstream `package-lock.json` dependency graph within the existing declared dependency ranges to resolve production dependency findings present at distribution creation time.
