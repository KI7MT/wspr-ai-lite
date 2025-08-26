# WSPR AI Lite Documentation

Welcome to the docs for **wspr-ai-lite** — a lightweight WSPR analytics dashboard built with **DuckDB** and **Streamlit**.

## Quick Links

- [User Setup](user-setup.md) — Installation & usage guide for end users
- [Developer Setup](developer-setup.md) — Dev environment, testing & contributions
- [Process Release](process-release.md) — Release workflow & PyPI publishing
- [Testing](testing.md) — Unit tests, smoke tests, CI details
- [Troubleshooting](troubleshooting.md) — Common issues & fixes
- [Code of Conduct](https://github.com/KI7MT/wspr-ai-lite/blob/main/CODE_OF_CONDUCT.md)
- [Security Policy](https://github.com/KI7MT/wspr-ai-lite/blob/main/SECURITY.md)

📘 Tip: The navigation menu on the left provides the same structure.

## About
Explore **Weak Signal Propagation Reporter (WSPR)** data with an easy, local dashboard:

- SNR distributions & monthly spot trends
- Top reporters, most-heard TX stations
- Geographic spread & distance/DX analysis
- QSO-like reciprocal reports
- Hourly activity heatmaps & yearly unique counts

Works on **Windows, Linux, macOS** — no heavy server required.

## Quickstart ( Recommended: PyPI)

### 1. Install from PyPI ( Python Package Repository )

> optional but recommended: [create a Pyton virtual environment](https://docs.python.org/3/library/venv.html) first

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install wspr-ai-lite
```

### 2. Ingest Data
Fetch WSPRNet monthly archives and load them into DuckDB:

> adjust the range as needed, but be reasonable!

```bash
wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb
```
- Downloads compressed monthly CSVs (caches locally in .cache/)
- Normalizes into data/wspr.duckdb
- Adds extra fields (band, reporter grid, tx grid)

### 3. Launch the Dashboard
```bash
wspr-ai-lite ui --db data/wspr.duckdb --port 8501
```
Open http://localhost:8501 in your browser 🎉

👉 For developers who want to hack on the code directly, see [Developer Setup](https://ki7mt.github.io/wspr-ai-lite/DEV_SETUP/).
