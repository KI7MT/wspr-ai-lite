# wspr-ai-lite — v0.4.0 Roadmap

Focus: UI/UX improvements, new CLI helpers, and laying MCP/Agent foundations.
The 0.3.x series concentrated on packaging, CI/CD, and stability.

---

## 1) User Experience (UI/UX)

- **Multi-Page Layout** (Streamlit `pages/` directory)
  - 📊 **Overview Dashboard** — summary stats, spot counts, unique TX/RX, activity heatmap.
  - 📡 **Propagation Explorer** — distance histograms, DX map.
  - 🎚 **Station Reports** — per-callsign breakdowns (RX/TX).
  - ⏱ **QSO Explorer** — reciprocal TX/RX window search.

- **Visual polish**
  - Consistent title-casing and units (MHz, dB, km).
  - Tooltips, filters, slicers (time, band, SNR).
  - Layout refinements (columns, tabs, expanders).

---

## 2) Ease of Use
- First-run guide if DB missing (ingest steps & sample command).
- Smarter caching: show cache location, size, and “clear cache” helper.
- Optional config file: `~/.wspr-ai-lite.toml` for default DB/cache.

---

## 3) CLI Enhancements
- `wspr-ai-lite stats` — total rows, distinct TX/RX, bands, min/max timestamps.
- `wspr-ai-lite verify` — table/column checks, simple integrity assertions.

---

## 4) Agent / MCP Foundations
- Extract a small internal API layer:
  - `wspr_ai_lite.api.query_spots()`
  - `wspr_ai_lite.api.get_summary()`
- Provide an MCP manifest stub for local experimentation.

---

## 5) Testing & Quality
- Smoke: run Streamlit with a tiny DB and confirm app loads (beyond import).
- Unit tests for `stats` and `verify`.
- Keep pre-commit + interrogate docstring coverage ≥ 80%.

---

## 6) Docs
- **User Guide**: multi-page walkthrough, QSO examples.
- **Developer Guide**: adding pages, extending CLI.
- **Changelog** remains single source; consider automation later.

---

### Deliverables for 0.4.0
- `src/wspr_ai_lite/pages/` with at least:
  - `01_Overview.py`
  - `02_Propagation.py`
- New CLI commands: `stats`, `verify`
- `wspr_ai_lite/api.py` with simple query helpers
- MCP manifest stub
- Updated Makefile & smoke tests
- Docs updated (User + Dev)
