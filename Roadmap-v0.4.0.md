## Roadmap v0.4.0

### Focus Areas
- **MCP Expansion**
  - Move MCP server from stub → working server loop (likely uvicorn).
  - Add more tools to match schema (`distance`, `azimuth`, `snr distribution`).
  - Support agent integration (natural language → MCP tools).
  - Define authn/authz stubs (roles, OAuth) for future enterprise scenarios.

- **UI Enhancements**
  - Polish existing Streamlit panels (distance/DX, QSO finder).
  - Add band label overlays (human-readable names alongside `band_code`).
  - Improve error handling when no data is available for selected filters.
  - Add sampling controls (max rows) for performance on large datasets.

- **Ingest Improvements**
  - Cross-platform archive handling finalized:
    - `.gz` (Linux/macOS), `.zip` (Windows), fallback `.csv`.
  - Deduplication by `spot_id` at ingest time.
  - Batch inserts for speed.

- **Dev/Tooling**
  - Pre-commit: finalize commitizen integration, auto-verify schema docs updated.
  - Add more `wspr-ai-lite-tools` subcommands:
    - `vacuum` (optimize DB),
    - `export` (Parquet/CSV slices),
    - `check` (data consistency, nulls, ranges).

---

### Stretch Goals
- **ClickHouse prototype**: Stand up schema + ingest path for large-scale datasets.
- **Agent demo**: Small natural language interface (e.g., “show me July 2014 20m band activity”).
- **Docs polish**: Add diagrams for ingest + MCP flow.
