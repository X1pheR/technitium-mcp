# Tool reference

This distribution verifies **31 tools in read-only mode** and **72 tools in read-write mode** against the live MCP `tools/list` contract.

## Safety semantics

- `READ_ONLY=true` removes mutating tools from the advertised server surface.
- In read-write mode, a read-only MCP bearer cannot invoke mutating tools; write scope is checked server-side.
- Tools marked **destructive** require `confirm: true` in addition to write scope.
- Inputs are schema-validated by the upstream MCP; the live MCP schema is authoritative for exact fields and types.
- The Technitium API token remains the provider authorization boundary.

## Complete tool table

| Tool | Access | Destructive | Purpose |
|---|---|:---:|---|
| `dns_audit_list` | read | no | List recent local MCP audit.jsonl entries in reverse chronological order. |
| `dns_audit_search` | read | no | Search local MCP audit.jsonl entries by text, tool, identity, action, request id, result, and date range. |
| `dns_audit_read` | read | no | Read one local MCP audit.jsonl entry by request_id. |
| `dns_health_check` | read | no | Summarize Technitium DNS health, version, uptime, forwarder config, and lifetime failure rate. |
| `dns_get_stats` | read | no | Get dashboard query statistics including top clients, domains, and blocked domains. |
| `dns_check_update` | read | no | Check whether a newer Technitium DNS Server version is available. |
| `dns_resolve` | read | no | Test DNS resolution through Technitium DNS Server without importing records. |
| `dns_whoami` | read | no | Get the current Technitium API token session identity and permissions. |
| `dns_metrics_prometheus` | read | no | Get Technitium lifetime metrics in Prometheus text format. |
| `dns_list_sessions` | read | no | List active Technitium user and API-token sessions. |
| `dns_create_api_token_file` | write | yes | Create a non-expiring Technitium API token for an existing user and write its one-time value directly to a bounded mode-0600 server-side file. The token value is never returned. Requires confirm: true. |
| `dns_delete_session` | write | yes | Delete a Technitium user or API-token session by partial token. Requires confirm: true. |
| `dns_list_zones` | read | no | List authoritative DNS zones configured in Technitium DNS Server. |
| `dns_zone_options` | read | no | Get zone DNSSEC, transfer, notify, dynamic update, and ACL options. |
| `dns_export_zone` | read | no | Export an authoritative zone file in BIND format using Technitium's required GET endpoint with a single-use token. |
| `dns_list_records` | read | no | List records for a domain or entire authoritative zone. |
| `dns_create_zone` | write | no | Create a new authoritative DNS zone. |
| `dns_delete_zone` | write | yes | Delete an authoritative DNS zone. Requires confirm: true. |
| `dns_enable_zone` | write | no | Enable a disabled authoritative zone. |
| `dns_disable_zone` | write | no | Disable an authoritative zone while preserving records. |
| `dns_set_zone_options` | write | no | Update zone notify, transfer ACL, query ACL, catalog, and dynamic update options. |
| `dns_add_record` | write | no | Add a DNS record to an authoritative zone. |
| `dns_update_record` | write | no | Update an existing DNS record by matching its current record fields and providing replacement fields. |
| `dns_delete_record` | write | yes | Delete a DNS record from an authoritative zone. Requires confirm: true. |
| `dns_list_blocked` | read | no | List blocked domains hierarchically with drill-down support. |
| `dns_list_allowed` | read | no | List allowed domains hierarchically with drill-down support. |
| `dns_list_cache` | read | no | List DNS cache zones and records hierarchically with drill-down support. |
| `dns_block_domain` | write | no | Add a domain to the custom blocked domains list. |
| `dns_remove_blocked` | write | no | Remove a domain from the custom blocked domains list. |
| `dns_flush_blocked` | write | yes | Flush the entire custom blocked domains list. Requires confirm: true. |
| `dns_allow_domain` | write | no | Add a domain to the allowed domains list to bypass block lists. |
| `dns_remove_allowed` | write | no | Remove a domain from the allowed domains list. |
| `dns_flush_allowed` | write | yes | Flush the entire allowed domains list. Requires confirm: true. |
| `dns_flush_cache` | write | yes | Flush the complete DNS cache. Requires confirm: true. |
| `dns_delete_cached` | write | no | Delete a specific domain from the DNS cache. |
| `dns_get_settings` | read | no | Get full Technitium DNS Server settings with sensitive fields sanitized. |
| `dns_query_logs` | read | no | Query Technitium DNS app logs with filters for client IP, protocol, response type, rcode, qname, qtype, and qclass. |
| `dns_list_apps` | read | no | List installed Technitium DNS apps. |
| `dns_list_app_store` | read | no | List apps available from the Technitium DNS app store. |
| `dns_get_app_config` | read | no | Get configuration for an installed Technitium DNS app. |
| `dns_dnssec_info` | read | no | Get DNSSEC properties for a signed or unsigned primary zone. |
| `dns_get_ds` | read | no | Get DS records for a DNSSEC-signed primary zone. |
| `dns_set_settings` | write | no | Update Technitium DNS Server settings by POSTing only the provided validated setting keys. |
| `dns_update_blocklists` | write | no | Force immediate Technitium block-list update. |
| `dns_temp_disable_blocking` | write | no | Temporarily disable Technitium blocking. Blocking auto re-enables after the requested minutes. |
| `dns_install_app` | write | no | Install a Technitium DNS app by name and HTTPS app-store/download URL. |
| `dns_uninstall_app` | write | yes | Uninstall a Technitium DNS app. Requires confirm: true. |
| `dns_dnssec_sign` | write | no | Sign a primary zone with DNSSEC using Technitium's DNSSEC signing API. |
| `dns_dnssec_unsign` | write | yes | Remove DNSSEC signing from a primary zone. Requires confirm: true. |
| `dns_dnssec_rollover_key` | write | yes | Rollover a DNSSEC DNSKEY by key tag. Requires confirm: true. |
| `dns_list_tsig_keys` | read | no | List configured TSIG key names without exposing shared secrets. |
| `dns_list_log_files` | read | no | List Technitium DNS server log files. |
| `dns_read_log_file` | read | no | Read a Technitium DNS server log file, optionally limited by megabytes. |
| `dns_export_query_logs` | read | no | Export filtered Technitium DNS app query logs as CSV text. |
| `dns_backup_settings` | write | no | Create a Technitium settings backup ZIP in the configured local backup directory. Requires write scope because backups can contain secrets. |
| `dns_restore_settings` | write | yes | Restore Technitium settings from a ZIP in the configured backup/import directory. Requires confirm: true. |
| `dns_download_update_app` | write | no | Download and update an installed Technitium DNS app from an HTTPS ZIP URL. |
| `dns_update_app` | write | no | Manually update an installed Technitium DNS app from a ZIP in the configured local import directory. |
| `dns_set_app_config` | write | no | Set an installed Technitium DNS app config object. |
| `dns_delete_log_file` | write | yes | Delete a Technitium DNS server log file. Requires confirm: true. |
| `dns_delete_all_logs` | write | yes | Delete all Technitium DNS server log files. Requires confirm: true. |
| `dns_dhcp_list_leases` | read | no | List Technitium DHCP leases. |
| `dns_dhcp_list_scopes` | read | no | List Technitium DHCP scopes. |
| `dns_dhcp_get_scope` | read | no | Get a full Technitium DHCP scope configuration. |
| `dns_dhcp_remove_lease` | write | yes | Remove a DHCP dynamic or reserved lease. Requires confirm: true. |
| `dns_dhcp_convert_lease_reserved` | write | no | Convert a DHCP dynamic lease to a reserved lease. |
| `dns_dhcp_convert_lease_dynamic` | write | no | Convert a DHCP reserved lease to a dynamic lease. |
| `dns_dhcp_set_scope` | write | no | Create or update a Technitium DHCP scope configuration. |
| `dns_dhcp_add_reserved_lease` | write | no | Add a reserved DHCP lease to a Technitium DHCP scope. |
| `dns_dhcp_remove_reserved_lease` | write | yes | Remove a reserved DHCP lease from a Technitium DHCP scope. Requires confirm: true. |
| `dns_dhcp_enable_scope` | write | no | Enable a Technitium DHCP scope. |
| `dns_dhcp_disable_scope` | write | no | Disable a Technitium DHCP scope while preserving its configuration. |
| `dns_dhcp_delete_scope` | write | yes | Delete a Technitium DHCP scope permanently. Requires confirm: true. |

## Deployment guidance

For monitoring or inspection, run with `READ_ONLY=true`. For administration, use a separate read-write bearer and expose that authority only to an explicitly trusted consumer. MCP group membership is not an authorization boundary by itself.

DHCP tools are present because they are part of the upstream MCP. Deployments that do not intend MCP-owned DHCP should restrict the underlying Technitium API authority and/or stay read-only until DHCP ownership is intentionally enabled.

Cluster-management operations are **not** part of this pinned upstream surface and require a separate supported management path.
