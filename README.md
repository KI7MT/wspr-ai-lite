# 📡 wspr-ai-lite

**Lightweight WSPR analytics with DuckDB + Streamlit**

[![CI](https://github.com/KI7MT/wspr-ai-lite/actions/workflows/ci.yml/badge.svg)](https://github.com/KI7MT/wspr-ai-lite/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Made with Streamlit](https://img.shields.io/badge/Made%20with-Streamlit-FF4B4B)](https://streamlit.io/)
[![DuckDB](https://img.shields.io/badge/Database-DuckDB-blue)](https://duckdb.org/)

Explore **Weak Signal Propagation Reporter (WSPR)** data with an easy, local dashboard:

- 📊 SNR distributions & monthly spot trends
- 👂 Top reporters, most-heard TX stations
- 🌍 Geographic spread & distance/DX analysis
- 🔄 QSO-like reciprocal reports
- ⏱ Hourly activity heatmaps & yearly unique counts

🚀 Works on **Windows, Linux, macOS** — no heavy server required.

---

## ✨ Features
- Local DuckDB storage with efficient ingest + caching
- Streamlit UI for interactive exploration
- Distance/DX analysis with Maidenhead grid conversion
- QSO-like reciprocal finder with configurable time window
- Ready-to-run on modest hardware

---

## 🚀 Quickstart

### 1. Clone & Setup
```bash
git clone git@github.com:KI7MT/wspr-ai-lite.git
cd wspr-ai-lite

# optional venv
python3 -m venv .venv && source .venv/bin/activate

pip install -r requirements.txt
```

### 2. Ingest Data
Fetch WSPRNet monthly archives and load them into DuckDB:

```bash
# adjust to whatever range you wish, but be reasonable !!
python pipelines/ingest.py --from 2014-07 --to 2014-07
```
- Downloads compressed monthly CSVs (caches locally)
- Normalizes into data/wspr.duckdb
- Adds extra fields (band, reporter grid, tx grid)

### 3. Run the UI
```bash
streamlit run app/wspr_app.py
```
Then open http://localhost:8501 in your browser.

---

📊 Example Visualizations
- SNR Distribution by Count
- Monthly Spot Counts
- Top Reporting Stations
- Most Heard TX Stations
- Geographic Spread (Unique Grids)
- Distance Distribution + Longest DX

---

📜 License
This project is licensed under the MIT License. Open and free for amateur radio and research use.

---

🙌 Acknowledgements
- WSPRNet community for providing global weak-signal data
- Joe Taylor, K1JT, and the WSJT-X Development Team
- Contributors to DuckDB and Streamlit
- Amateur radio operators worldwide who share spots and keep the network alive

---

📬 Contributing
Pull requests are welcome!
If you have feature ideas (e.g., new metrics, visualizations, or AI integrations), open an issue first to discuss.

---

🔮 Roadmap
- 📦 Phase 1: wspr-ai-lite (this project)
- Lightweight, local-only DuckDB + Streamlit dashboard
- 🚀 Phase 2: wspr-ai-analytics
- Full analytics suite with ClickHouse, Grafana, AI Agents, and MCP integration
- Designed for heavier infrastructure and richer analysis
