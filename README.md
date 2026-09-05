# Technitium DNS MCP — X1pheR Distribution

[![CI](https://github.com/X1pheR/technitium-mcp/actions/workflows/ci.yml/badge.svg)](https://github.com/X1pheR/technitium-mcp/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/X1pheR/technitium-mcp)](https://github.com/X1pheR/technitium-mcp/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/X1pheR/technitium-mcp/badge)](https://scorecard.dev/viewer/?uri=github.com/X1pheR/technitium-mcp)

Community-maintained container distribution of [`Slyke/mcp-technitium-dns`](https://github.com/Slyke/mcp-technitium-dns), an MCP server for managing and observing [Technitium DNS Server](https://github.com/TechnitiumSoftware/DnsServer).

This repository is **not an official Technitium or Slyke project** and is not endorsed by either project. It keeps the upstream application source pinned and recognizable while adding a separately maintained distribution, supply-chain, and release boundary.

## Why this distribution exists

The upstream MCP has a security-oriented application boundary: separate read/read-write bearer identities, a global read-only mode, confirmation gates for destructive operations, rate limits, audit logging, response sanitization, and file-backed Technitium API-token support. This distribution makes that reviewed source consumable as an immutable container release with reproducible verification.

The distribution adds an exact upstream commit pin, a reviewed dependency-lock refresh without application-source changes, a digest-pinned Node base image, a non-root runtime with npm/npx removed, CI/security/release provenance, and a verified [complete tool reference](docs/tools.md).

## Compatibility baseline

| Component | Tested baseline |
|---|---|
| Upstream MCP | commit `0b8f0478f4e759b17fe5d1410a72659fb3f61bfb` |
| Upstream package | `0.0.1` |
| Distribution | `0.0.1-x1pher.1` |
| Technitium DNS Server | `15.4.0` |
| Runtime | Node 22 Alpine, base image pinned by digest |

A newer upstream commit or Technitium release is not automatically supported; compatibility is established by updating the pin, reviewing the delta, and rerunning the full verifier.

## Image

Published releases use `ghcr.io/x1pher/technitium-mcp:<distribution-version>`, for example `ghcr.io/x1pher/technitium-mcp:0.0.1-x1pher.1`.

## Security model

The **Technitium API token remains the upstream authorization boundary**. Give it only the permissions its deployment needs.

`READ_ONLY=true` removes all mutating tools from the advertised MCP surface. With read-write mode enabled, MCP bearer identities still carry either read or read-write scope; mutating calls made with a read bearer are denied server-side. Destructive operations additionally require `confirm: true`.

The tested surface contains **31 tools in read-only mode** and **72 tools in read-write mode**. See [`docs/tools.md`](docs/tools.md).

Do not publish the MCP listener directly to an untrusted network. Prefer a private network path and mount the Technitium API token from a protected file using `TECHNITIUM_API_TOKEN_FILE`.

## Representative configuration

```text
TECHNITIUM_BASE_URL=http://technitium:5380
TECHNITIUM_ALLOW_HTTP_LOCAL=true
TECHNITIUM_API_TOKEN_FILE=/run/secrets/technitium-api-token
MCP_READ_BEARER_TOKENS=[{name:"reader",token:"replace-me"}]
READ_ONLY=true
HTTPS_ENABLED=true
HTTP_ENABLED=false
```

The example bearer value is synthetic. Use protected secret delivery and a trusted TLS configuration where appropriate.

## Build and verify locally

Run `./scripts/verify.sh`. It checks the documented upstream delta, upstream tests, production dependency audit, source/config security scans, container hardening, final-image vulnerabilities, and both live MCP tool surfaces against `tools-manifest.json`.

## Release model

```text
upstream package: 0.0.1
distribution:     0.0.1-x1pher.1
Git tag:          v0.0.1-x1pher.1
image tag:        0.0.1-x1pher.1
```

Release automation re-runs the canonical verifier, publishes the versioned GHCR image, records its digest, creates build provenance, and publishes the matching GitHub Release.

## Upstream relationship and license

The upstream source snapshot is stored under `upstream/`. `UPSTREAM.json` records the exact source commit and allowed downstream delta. Application behavior remains upstream-owned unless a future source-level delta is explicitly documented.

See [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md), the root [`LICENSE`](LICENSE), and upstream [`LICENSE.md`](upstream/LICENSE.md).

## Feedback and security

Use GitHub Issues for non-sensitive distribution defects. See [`CONTRIBUTING.md`](CONTRIBUTING.md) and [`SECURITY.md`](SECURITY.md).
