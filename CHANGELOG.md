# Changelog

## [Unreleased]

## [0.0.1-x1pher.2] - 2026-09-07

### Added
- Added `dns_create_api_token_file`, a confirmation-gated write tool that creates a Technitium API token for an existing user and writes the one-time value only to a configured bounded server-side file with mode `0600`.
- Added regression coverage for traversal rejection, no-overwrite semantics, token non-disclosure, duplicate-token retry safety, configurable secret-output storage, and the official `/api/admin/sessions/createToken` request contract.

### Security
- Token values created by `dns_create_api_token_file` never appear in MCP arguments, responses, or audit entries. The output file is reserved before the remote token is minted, and handled publication failures attempt to delete the newly created session before returning an error.
- The distribution now carries an explicit reviewed security-integration source delta; `UPSTREAM.json` enumerates every changed upstream file and the verifier rejects any delta outside that list.

## [0.0.1-x1pher.1] - 2026-09-05

### Added
- First X1pheR distribution of `Slyke/mcp-technitium-dns`, pinned to upstream commit `0b8f0478f4e759b17fe5d1410a72659fb3f61bfb`.
- Hardened non-root container packaging with a digest-pinned Node base image and runtime package-manager removal.
- Reproducible verification for upstream parity, tests, dependency audit, security scans, container hardening, and MCP tool-contract parity.

### Security
- Refreshed only the upstream `package-lock.json` dependency graph within the existing declared dependency ranges to resolve production dependency findings present at distribution creation time.
