# User Guide

This page mirrors the core usage instructions from the project README so it renders in the MkDocs site.

> NOTE - This section is under heavy development. Expect new content often as the project grows.

## Quickstart

1. **Create a virtual environment (optional but recommended)**
   ```bash
   python3 -m venv .venv && source .venv/bin/activate
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Ingest a sample month (e.g., July 2014)**
   ```bash
   python pipelines/ingest.py --from 2014-07 --to 2014-07
   ```

4. **Run the Streamlit UI**
   ```bash
   streamlit run app/wspr_app.py
   ```
   Open http://localhost:8501 in your browser.

## Notes

- Data is stored locally in `data/wspr.duckdb`.
- The ingest script caches downloads and can clean caches with `--clean-cache`.
- See the Makefile for shortcuts:
  ```bash
  make setup-dev   # create venv + install deps
  make ingest      # ingest sample month
  make run         # run Streamlit UI
  make test        # run pytest suite
  ```

For more details, refer to the repository README on GitHub.

## Command Line Interface Scripts

Along with the UI comes several command line interface ( CLI ) applicaitons. The following is a brief description of each, and it's basic usage
All scripts have a help function, e.g.: `<app-name> --help`
```bash
# ingest from WSPRnet into the DuckDB columnar database
wspr-ai-lite ingest --from YYYY-MM --to YYYY-MM --db data/wspr.duckdb [--cache .cache/wspr] [--offline]

# fetch one or more WSPRNet archives and stor locally
wspr-ai-lite-fetch --from YYYY-MM --to YYYY-MM --cache .cache/wspr [--force]

# launch the wspr-ai-lite user interface
wspr-ai-lite ui --db data/wspr.duckdb --port 8501

# set of tookls to check and verify database integrity and / or migrate from one schema to the standard
wspr-ai-lite-tools stats|verify [--strict] [--explain] | migrate [--no-backup]

# Model Concept Protocol Server -  The Database interface for AI Agents
wspr-ai-lite-mcp serve --db data/wspr.duckdb [--init] [--host 127.0.0.1] [--port 8765]
```
