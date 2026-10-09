# Upstream convergence

- Upstream: https://github.com/Slyke/mcp-technitium-dns
- Downstream: https://github.com/X1pheR/technitium-mcp
- Current documented comparison baseline: v0.0.1

## Machine-readable patch register

This is a source-history-based initial logical patch inventory and must be reconciled against an exact upstream tree, current GitHub issue/PR state and the canonical product contract before it can be called exhaustive or compliant. The missing upstream links intentionally fail the current SDLC policy. Product-specific operational changes should move out of the fork when possible. No divergence ADR is approved, and these records do not grandfather one.

<!-- SDLC-UPSTREAM-REGISTER:1 -->
```json
{
  "schema_version": 1,
  "upstream": "Slyke/mcp-technitium-dns",
  "baseline": "v0.0.1",
  "patches": [
    {
      "id": "TN-P01",
      "kind": "upstream",
      "scope": "Secret-safe Technitium API token input and handoff",
      "local_commits": [
        "896ae28"
      ],
      "checked_on": "2026-10-10",
      "issue": null,
      "pr": null
    },
    {
      "id": "TN-P02",
      "kind": "upstream",
      "scope": "Downstream distribution and release packaging",
      "local_commits": [
        "3980b01",
        "3c4fd69"
      ],
      "checked_on": "2026-10-10",
      "issue": null,
      "pr": null
    },
    {
      "id": "TN-P03",
      "kind": "upstream",
      "scope": "Vulnerable transitive dependency and Actions baseline maintenance",
      "local_commits": [
        "29cf12c",
        "a83b8d7"
      ],
      "checked_on": "2026-10-10",
      "issue": null,
      "pr": null
    }
  ]
}
```

## Upstream-first exit

For each patch, first check whether the official current upstream source or an existing issue and PR already cover its behavior. Do not open duplicate contributions. Preserve one logical patch for an iterative fix. Publish only a tested upstream-compatible contribution after the repository's established acceptance gates. Once the exact patch merges, require inclusion in an immutable official release and candidate regression evidence before removing the downstream delta. An approved intentional divergence requires a separate operator decision and accepted exact-scope product ADR. End fork maintenance only after release adoption, desired state, rollback readiness, live acceptance and explicit retirement gates. No automatic production or database migration is authorized by this register.
