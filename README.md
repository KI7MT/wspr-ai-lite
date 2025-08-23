# wspr-ai-lite

Lightweight WSPR (Weak Signal Propagation Reporter) analytics powered by **DuckDB** + **Streamlit**.

## Features
- Year/Band filters, SNR distribution, monthly counts
- Top reporting stations & most heard TX stations
- Geographic spread (unique grids)
- Distance distribution & longest DX; best DX per band
- Station-centric: My TX/RX stats, Reciprocal Heard (QSO-like)
- Avg SNR by month, activity by hour × month
- Unique stations by year trend
- Robust CLI ingest with caching

## Quickstart
```bash
# 1) Create/activate a venv (optional but recommended)
python3 -m venv .venv && source .venv/bin/activate

# 2) Install deps
pip install -r requirements.txt

# 3) Ingest some data
python pipelines/ingest.py --from 2014-07 --to 2014-07

# 4) Run the UI
streamlit run app/wspr_app.py
```

## Project Layout
```
app/                 # Streamlit app
pipelines/           # Ingest pipeline (CLI)
tests/               # Pytest unit tests
docs/                # Developer & testing docs
data/                # DuckDB database (created after ingest)
```

## License
MIT (see LICENSE).

---

**Project-2 (wspr-ai-analytics)** will target ClickHouse + Grafana + Agents/MCP later.
