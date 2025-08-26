# Quickstart (Recommended: [PyPI](https://pypi.org/project/wspr-ai-lite/))

## 1. Install from PyPI

> optional but recommended: [create a Python virtual environment](https://docs.python.org/3/library/venv.html) first

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install wspr-ai-lite
```

## 2. Ingest Data
Fetch WSPRNet monthly archives and load them into DuckDB:

```bash
wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb
```
- Downloads compressed monthly CSVs (caches locally in .cache/)
- Normalizes into data/wspr.duckdb
- Adds extra fields (band, reporter grid, tx grid)

## 3. Launch the Dashboard
```bash
wspr-ai-lite ui --db data/wspr.duckdb --port 8501
```
Open http://localhost:8501 in your browser 🎉

👉 For developers who want to hack on the code directly, see [Developer Setup](https://ki7mt.github.io/wspr-ai-lite/DEV_SETUP/).
