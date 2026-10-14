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
      "issue": "https://github.com/Slyke/mcp-technitium-dns/issues/2",
      "pr": "https://github.com/Slyke/mcp-technitium-dns/pull/3",
      "pr_state": "draft"
    },
    {
      "id": "TN-P02",
      "kind": "upstream",
      "scope": "Downstream-only image/release packaging, pinned Docker CI workflow and actions/attest maintenance",
      "local_commits": [
        "3980b01",
        "3c4fd69",
        "a83b8d7"
      ],
      "checked_on": "2026-10-10",
      "issue": null,
      "pr": null
    },
    {
      "id": "TN-P03",
      "kind": "upstream",
      "scope": "Generic transitive dependency security and lockfile version baseline refresh",
      "local_commits": [
        "29cf12c"
      ],
      "checked_on": "2026-10-10",
      "issue": "https://github.com/Slyke/mcp-technitium-dns/issues/4",
      "pr": "https://github.com/Slyke/mcp-technitium-dns/pull/5",
      "pr_state": "draft"
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
- **TN-P02** is still Hypershell downstream release/packaging source and
  requires decomposition into upstream-compatible build fixes versus
  distribution-specific ownership or exact-scope approved exceptions.
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
  TN-P02 remains unlinked/unapproved, and no downstream production
  release is justified by either draft PR.

## Upstream-first exit

For each patch, first check whether the official current upstream source or an existing issue and PR already cover its behavior. Do not open duplicate contributions. Preserve one logical patch for an iterative fix. Publish only a tested upstream-compatible contribution after the repository's established acceptance gates. Once the exact patch merges, require inclusion in an immutable official release and candidate regression evidence before removing the downstream delta. An approved intentional divergence requires a separate operator decision and accepted exact-scope product ADR. End fork maintenance only after release adoption, desired state, rollback readiness, live acceptance and explicit retirement gates. No automatic production or database migration is authorized by this register.


## Unapproved distribution disposition proposal — TN-P02

This is a proposal for an operator decision, not an approved ADR or a conformance exception. The register row remains unlinked and nonconformant. Exact source candidate: `33343b574963427fcc94b3b8f1dcd4caea6fc0ce`; mapped historical commits: `3980b01`, `3c4fd69`, `a83b8d7`. Initial/import commits can contain baseline and unrelated application files; approval must not cover the entire mapped commit merely because it appears in this row.

Proposed narrow scope: Only product identity, Docker/runtime packaging, canonical source verifier, repository security automation and owned release/attestation wrappers. The initial import includes upstream application source; it does not grant an exception for that source or for secret-handling and dependency patches TN-P01/P03.

Requested decision: retain this precisely bounded product-owned distribution adapter, or move/remove it through the existing source/release/deployment owners when the upstream artifact supplies an equivalent accepted distribution. Our package names, registry targets and operator release controls do not constitute a useful upstream feature request; do not manufacture an issue/PR asking upstream to adopt downstream ownership. Any reusable application or verification improvement discovered in this history still needs its own tested upstream-compatible contribution.

Before an approved disposition can clear a gate, the operator-owned product ADR must identify the exact retained scope, rationale, owner, acceptance evidence and review/exit trigger. Proposed review trigger: the next suitable official upstream release or2026-11-14, whichever comes first. Exit requires equivalent released functionality and distribution, accepted source/runtime/consumer parity, rollback readiness and the existing explicit production/retirement acceptance. This proposal authorizes none of those transitions and approves no missing contribution.

The existing shared repository/release lifecycle invokes the single canonical SDLC checker before managed tag/publication/recovery transitions. Direct public workflow integration remains incomplete: the checker source is private and repository-scoped public GitHub tokens cannot read it. No production credentials, privileged public runner, second checker or extra service was introduced.
