# wspr-ai-lite Documentation
Lightweight WSPR analytics and AI‑ready backend using **DuckDB** + **Streamlit**, with data-safe query access via **MCP Agents**.

## Resources

[![MCP](https://img.shields.io/badge/AI--Agent--Ready-MCP-green)](https://modelcontextprotocol.io/)
[![Made with Streamlit](https://img.shields.io/badge/Made%20with-Streamlit-blue)](https://streamlit.io/)
[![DuckDB](https://img.shields.io/badge/Database-DuckDB-blue)](https://duckdb.org/)
[![Docs](https://img.shields.io/badge/Docs-GitHub_Pages-blue)](https://ki7mt.github.io/wspr-ai-lite/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Overview
`wspr-ai-lite` is a lightweight analytics tool for **Weak Signal Propagation (WSPR)** data.
It combines **DuckDB** for local storage, **Streamlit** for visualization, and is now **AI-Agent ready** via MCP.

- **MCP Integration**: Experimental MCP server (`wspr-ai-lite-mcp`) exposing safe APIs for AI agents. A manifest defines permitted queries and access control.
- **Analytics Dashboard**: Streamlit UI lets you explore WSPR spots with SNR trends, DX distance analysis, station activity, and “QSO‑like” reciprocity views.
- **Canonical Schema**: Data is normalized into a portable DuckDB file—consistent, lightweight, and ready for future backend upgrades.
- **CLI Tools**: Click-based tools (`wspr-ai-lite`, `wspr-ai-lite-fetch`, `wspr-ai-lite-tools`) for downloading, ingesting, verifying, and managing the database.
- **Roadmap (v0.4+ vision)**: MCP server will migrate to a **FastAPI + Uvicorn** backend with service control (start/stop/restart), enabling production-grade deployment.

---

## Technology Stack Key Benefits

**MCP & AI Agents** — safe, structured access for AI assistants.
- Controlled: manifest defines exactly what tools/queries are exposed.
- Interoperable: model-agnostic, works across many LLMs.
- Extendable: add analytics or summary tools without altering the DB/UI.
- Future-ready: aligns with open standards for AI-assisted research.

**DuckDB** — an embedded, columnar SQL database optimized for analytics.
- High performance: in-memory processing, vectorized execution, columnar storage.
- Lightweight: no external server needed, works anywhere Python runs.
- Flexible: reads/writes CSV, Parquet, JSON; integrates directly with Pandas.

**Streamlit** — a Python-first framework for interactive data apps.
- Rapid prototyping: build dashboards with just Python.
- Interactive: real-time widgets, dynamic filters, custom layouts.
- Visualization: integrates with Matplotlib, Plotly, Altair, and more.

---

## Quick Workflow
1. **Fetch + Ingest Data** → Download WSPRNet monthly archives, normalize into DuckDB.
2. **Explore in UI** → Interactive dashboard with SNR, trends, distance/DX, activity heatmaps.
3. **Optional: MCP Tools** → Query WSPR data safely from AI agents.

## Documentation Index
- [Ingest Data](userguide/cli/ingest.md) — Fetch and normalize WSPRNet archives into DuckDB.
- [UI Guide](userinterface/ui.md) — Launch and navigate the Streamlit dashboard.
- [Developer Setup](development/developer-setup.md) — Get started contributing to wspr-ai-lite.

---

### Further Reading
- [Contributing](CONTRIBUTING.md)
- [Roadmap](ROADMAP.md)
- [Issue Tracker](https://github.com/KI7MT/wspr-ai-lite/issues)
