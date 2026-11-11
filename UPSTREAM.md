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
      "checked_on": "2026-11-11",
      "issue": "https://github.com/Slyke/mcp-technitium-dns/issues/2",
      "pr": "https://github.com/Slyke/mcp-technitium-dns/pull/3",
      "pr_state": "draft"
    },
    {
      "id": "TN-P02",
      "kind": "distribution",
      "scope": "Temporary own version/image publication and narrowly pinned runtime OS packages required to safely distribute retained unreleased upstream source fixes",
      "local_commits": [
        "3980b01",
        "3c4fd69",
        "a83b8d7",
        "ae56011f14b3e2e37e1ae9a9f6a854be3e95762d"
      ],
      "checked_on": "2026-11-11",
      "temporary": true,
      "depends_on": [
        "TN-P01",
        "TN-P03",
        "TN-P04"
      ],
      "exit_when": "A suitable official upstream artifact includes TN-P01, TN-P03 and TN-P04, an accepted fixed base image no longer requires the temporary OS pins, and source, consumer and rollback parity permit retiring the own image/tag/release workflow."
    },
    {
      "id": "TN-P03",
      "kind": "upstream",
      "scope": "Generic transitive dependency security and lockfile version baseline refresh",
      "local_commits": [
        "29cf12c"
      ],
      "checked_on": "2026-11-11",
      "issue": "https://github.com/Slyke/mcp-technitium-dns/issues/4",
      "pr": "https://github.com/Slyke/mcp-technitium-dns/pull/5",
      "pr_state": "draft"
    },
    {
      "id": "TN-P04",
      "kind": "upstream",
      "scope": "Patch Zod 4 and security-sensitive transitive npm dependency locks",
      "local_commits": [
        "1d7788e09636347d1694c0c8d1384d016654aae1"
      ],
      "checked_on": "2026-11-11",
      "issue": "https://github.com/Slyke/mcp-technitium-dns/issues/6",
      "pr": "https://github.com/Slyke/mcp-technitium-dns/pull/7",
      "pr_state": "open"
    }
  ]
}
```

## Verified upstream contribution state (2026-10-10)

- The official `Slyke/mcp-technitium-dns:master` baseline is
  `0b8f0478f4e759b17fe5d1410a72659fb3f61bfb`, which matches the
  pinned upstream source snapshot in this distribution's `UPSTREAM.json`.
  A missing upstream Git remote was corrected with a fetch-only upstream
  URL and disabled upstream push.
- **TN-P01** is now represented by upstream
  [issue #2](https://github.com/Slyke/mcp-technitium-dns/issues/2) and
  [draft PR #3](https://github.com/Slyke/mcp-technitium-dns/pull/3).
  The exact upstream-native contribution head is
  `19985c86abe25053b3653903c1a24616e25b8130`, based on the pinned
  official master. The independent `X1pheR/mcp-technitium-dns` GitHub
  fork exists **solely as a PR contribution transport**. It is not a new
  Hypershell product, release owner or deployment source.
- The secret-safe file workflow was tested before implementation
  (missing-module failures) and the full official `npm run check` passed
  **32/32** Node 22 tests after implementation. Additional regression
  coverage exposed and then fixed symlinked output root redirection and
  missing structured rollback-uncertainty results. No real token or
  production Technitium API was contacted; synthetic values and temporary
  files were used. The PR is **draft**, not yet upstream CI accepted,
  reviewed, merged or included in an immutable official release. Token
  lifecycle, directory trust and concurrent rollback semantics remain
  explicit security-review gates.
- **TN-P02** is the temporary release-only distribution record for linked upstream fixes TN-P01 and TN-P03; unrelated generic source/build changes are not covered by it.
- **TN-P03** is separately linked to upstream
  [issue #4](https://github.com/Slyke/mcp-technitium-dns/issues/4) and
  [draft PR #5](https://github.com/Slyke/mcp-technitium-dns/pull/5),
  exact contribution head `6a86113455d665704bb53a0db52eab72204d2551`.
  The reviewed lockfile moves `fast-uri` from 3.1.3 to 3.1.8 and
  `@modelcontextprotocol/sdk` from 1.29.0 to 1.32.1, and aligns root
  version 0.1.0 to the official package.json value 0.0.1.
  The new dependency-lock contract was first red then green; a fresh
  `npm ci` and the full official `npm run check` passed against the
  upstream-native candidate. This is a **draft**, not an accepted
  upstream security audit, CI result, merge or immutable release inclusion.
  The Actions attest bump in downstream commit `a83b8d7` only changes
  the Hypershell-owned `.github/workflows/release.yml`, not upstream
  dependencies: its ownership has been corrected to **TN-P02**.
  TN-P02 distribution is linked to both draft upstream patches. No downstream production release is justified solely by their open PRs.

## Upstream-first exit

For each patch, first check whether the official current upstream source or an existing issue and PR already cover its behavior. Do not open duplicate contributions. Preserve one logical patch for an iterative fix. Publish only a tested upstream-compatible contribution after the repository's established acceptance gates. Once the exact patch merges, require inclusion in an immutable official release and candidate regression evidence before removing the downstream delta. An approved intentional divergence requires a separate operator decision and accepted exact-scope product ADR. End fork maintenance only after release adoption, desired state, rollback readiness, live acceptance and explicit retirement gates. No automatic production or database migration is authorized by this register.


## Temporary distribution exit — TN-P02

The own image/version and release workflow are temporary distribution for the still-pending upstream source fixes. Secret-handling and dependency changes remain independent upstream patches; canonical verifier and CI security checks remain ordinary product-owned checks, not exempt source patches. Remove own distribution only after official upstream artifact and separately accepted consumer/rollback parity. No release or deployment is authorized.
