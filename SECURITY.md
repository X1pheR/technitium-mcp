# Security Policy

## Scope

This repository owns the container/distribution boundary around [`Slyke/mcp-technitium-dns`](https://github.com/Slyke/mcp-technitium-dns). Report issues here when they concern this distribution's packaging, dependency lock delta, verification/release workflow, published image, provenance, or documentation.

For vulnerabilities in upstream MCP application behavior, also use the upstream project's available security/support channels.

## Reporting

Use [GitHub private vulnerability reporting](https://github.com/X1pheR/technitium-mcp/security/advisories/new) for a suspected vulnerability in this distribution. Do not include real credentials, DNS configuration exports, private hostnames, session material, or other sensitive values in a public issue.

For a non-sensitive distribution defect, a normal GitHub issue is appropriate. If private vulnerability reporting is unexpectedly unavailable, provide only a minimal non-sensitive public notice requesting a private channel and wait before sharing sensitive reproduction material.

## Supported versions

Only the current published distribution release is maintained. A newer upstream commit is not automatically supported until it has been reviewed, pinned, verified, and released through this distribution.

## Security boundary

The upstream MCP provides separate read/read-write identities, a global read-only mode, destructive confirmation gates, request rate limits, local audit logging, response sanitization, and file-backed provider authentication. The distribution preserves those controls and adds a non-root container, digest-pinned base image, locked production dependencies, runtime package-manager removal, and repeatable source/image security scans.

Deployments remain responsible for least-privilege provider permissions, private network placement, protected authentication files, and choosing read-only versus read-write MCP authority. Do not expose the MCP listener directly to an untrusted network.
