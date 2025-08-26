# wspr-ai-lite Documentation
Lightweight WSPR analytics and AI‑ready backend using **DuckDB** + **Streamlit**, with safe query access via **MCP Agents**.

[![Made with Streamlit](https://img.shields.io/badge/Made%20with-Streamlit-FF4B4B)](https://streamlit.io/)
[![DuckDB](https://img.shields.io/badge/Database-DuckDB-blue)](https://duckdb.org/)
[![MCP](https://img.shields.io/badge/AI--Agent--Ready-MCP-green)](https://modelcontextprotocol.io/)
[![Docs](https://img.shields.io/badge/Docs-GitHub_Pages-blue)](https://ki7mt.github.io/wspr-ai-lite/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Overview
`wspr-ai-lite` is a lightweight analytics tool for **Weak Signal Propagation Reporter (WSPR)** data.
It combines **DuckDB** for local storage, **Streamlit** for visualization, and is now **AI-Agent ready** via MCP.

## Quick Workflow
1. **Fetch + Ingest Data** → Download WSPRNet monthly archives, normalize into DuckDB.
2. **Explore in UI** → Interactive dashboard with SNR, trends, distance/DX, activity heatmaps.
3. **Optional: MCP Tools** → Query WSPR data safely from AI agents.

## Documentation Index
- [Ingest Data](ingest.md) — Fetch and normalize WSPRNet archives into DuckDB.
- [UI Guide](userinterface/ui.md) — Launch and navigate the Streamlit dashboard.
- [Developer Setup](developer-setup.md) — Get started contributing to wspr-ai-lite.

---
### Further Reading
- [Contributing](CONTRIBUTING.md)
- [Roadmap](ROADMAP.md)
- [Issue Tracker](https://github.com/KI7MT/wspr-ai-lite/issues)
