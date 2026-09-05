# Contributing

This repository maintains a thin distribution of `Slyke/mcp-technitium-dns`. Upstream application behavior should normally remain upstream; this repository owns packaging, dependency-lock security, release provenance, verification, and narrowly justified distribution changes.

## Before proposing a change

- Keep unrelated application-source changes out of the vendored `upstream/` tree.
- Preserve explicit upstream provenance in `UPSTREAM.json`.
- Treat changes to the pinned upstream commit or dependency graph as compatibility work.
- Use synthetic values in tests and examples; never include production configuration or private infrastructure details.
- Keep deployment-specific hostnames, ports, credentials, and consumer projections outside this reusable product.

## Validation

Run `./scripts/verify.sh`. The verifier checks upstream parity, the allowed downstream delta, upstream tests, production dependency audit, source/config security scans, container hardening, and the exact read-only/read-write MCP tool contracts.

Update `docs/tools.md` and `tools-manifest.json` whenever the exposed MCP contract changes. Security-sensitive reports must follow `SECURITY.md` rather than a public issue or pull request.
