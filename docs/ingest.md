# Ingesting WSPR Data

## Overview
The ingest pipeline normalizes monthly WSPRNet archives into the **canonical DuckDB schema**.

## Commands
Fetch and ingest archives into DuckDB:

```bash
wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb --cache .cache/wspr
```

### Options
- `--from YYYY-MM` : Start month
- `--to YYYY-MM`   : End month (inclusive)
- `--db`           : Path to DuckDB file
- `--cache`        : Local directory for downloaded `.gz` files
- `--offline`      : Ingest from cache only, skip network fetch

## Archive Formats
- **Linux/macOS**: Monthly archives are served as `.csv.gz`
- **Windows**: Some mirrors provide `.zip` archives — support planned in upcoming versions.

## Example
```bash
# Download + ingest January–March 2015
wspr-ai-lite ingest --from 2015-01 --to 2015-03 --db data/wspr.duckdb
```

---
### Further Reading
- [Streamlit UI](ui.md)
- [Developer Setup](developer-setup.md)
- [Roadmap](ROADMAP.md)
