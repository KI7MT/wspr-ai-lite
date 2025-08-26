# Project Roadmap

This document outlines the planned features, improvements, and direction for **wspr-ai-lite**.
The roadmap is a living document and may evolve as priorities shift.

---

## v0.4.x ( Planned )

## UI Enhancements
  - Refine Streamlit dashboards to ensure all panels align with canonical schema.
  - Improve filtering (multi-band, multi-year queries).
  - Add export options (CSV/Parquet) for selected results.

## AI MCP / AI Agent Integration
  - Replace stubbed MCP server with a working implementation (likely via uvicorn).
  - Support real-time query handling through the MCP contract.
  - Explore initial agent integration workflows.

## Cross-Platform Ingestion
  - Support both `*.csv.gz` (Linux/macOS) and `*.zip` (Windows) archives.
  - Unified interface for fetch/ingest regardless of platform.

## Tooling
  - Extend `wspr-ai-lite-tools` with additional commands:
    - `analyze` for data summaries (SNR, distance, TX/RX trends).
    - `repair` for fixing or deduplicating rows.
  - Strengthen schema verification with optional auto-fix.

---

## Longer-Term Ideas
- ClickHouse backend for large-scale deployments.
- WebSocket live feed for near-real-time spots ingest.
- Agent workflows with natural-language queries against MCP.
- Packaging: Windows binaries via PyInstaller.
- Documentation**: Expand “getting started” with platform-specific guides.

---

## Notes
- Changes targeting a specific release will also be tracked in `CHANGELOG.md`.
- This file remains the high-level vision; implementation details live in issues and PRs.
