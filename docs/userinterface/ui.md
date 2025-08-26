# User Interface Overview

## Launching the UI
After ingesting data, launch the Streamlit dashboard:

```bash
wspr-ai-lite ui --db data/wspr.duckdb --port 8501
```

Open [http://localhost:8501](http://localhost:8501) in your browser.

## Key Features
- **SNR Distributions** — histogram of received SNR values.
- **Monthly Trends** — counts of spots per month.
- **Top Reporters & TX Stations** — who hears and who is heard.
- **Geographic Spread** — unique reporter and TX grids.
- **Distance/DX** — haversine-based distance from Maidenhead locators.
- **Reciprocal QSO Finder** — near-simultaneous bidirectional spots.

## Filters
- **Year** and **Band** selectors in sidebar.
- Callsign inputs for station-centric views.
- QSO parameters: time window, same-band requirement.

## Example Screens (to be added)
- Histogram of SNR values
- Bar chart of monthly counts
- Distance distribution with longest DX highlight

---
### Further Reading
- [Ingest Data](../userguide/cli/ingest.md)
- [Contributing](../CONTRIBUTING.md)
- [Roadmap](../ROADMAP.md)
