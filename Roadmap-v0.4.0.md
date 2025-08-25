# wspr-ai-lite — v0.4.0 Roadmap

Focus: **Agent-ready interfaces, advanced UI analytics, and stronger DB tooling.**

---

## 1) MCP / Agents
- Extend MCP server with more tools:
  - `stats` (summary by year/band).
  - `qso_finder` (reciprocal TX/RX).
  - `distance_dx` (longest DX per band).
- Add structured output schemas for tool responses (JSON Schema alignment).
- Prepare a minimal example Agent that queries the MCP and returns results.

## 2) UI Enhancements
- Migrate to multi-page Streamlit (`pages/`).
- Add dedicated pages for:
  - **Overview Dashboard** (key stats, trends).
  - **Propagation Explorer** (band activity, distance histograms, DX map).
  - **Station Reports** (TX/RX stats, QSO-like matches).
- Improve caching and query performance (use `spots_v` views).

## 3) CLI / Tools
- Add `wspr-ai-lite-tools qso` command (reciprocal heard, heuristic success rate).
- Add `wspr-ai-lite-tools bands` command (summarize band activity).
- Improve `migrate` with dry-run mode and schema diffs.

## 4) Data & Schema
- Support **incremental ingest** (skip already ingested months).
- Add derived `day` and `hour` columns directly to `spots_v`.
- Consider optional FTS index for callsigns (DuckDB extension).

## 5) Testing & Quality
- End-to-end ingest → verify → UI smoke test.
- Add unit tests for MCP tools.
- Improve schema validation in `verify` (check types + constraints).

## Deliverables for 0.4.0
- `src/wspr_ai_lite/pages/*` (multi-page Streamlit app).
- Extended MCP tools + example agent.
- New CLI commands: `qso`, `bands`.
- Incremental ingest implementation.
- Documentation updates: MCP usage guide, Tools CLI guide.
