# Ingestion Pipeline

This document describes how WSPR monthly archives are downloaded, cached, and ingested into DuckDB.

## Archive Formats

The WSPRNet monthly archives may appear in different formats depending on platform and mirror:

- **`.csv.gz`** — standard format on wsprnet.org (Linux/macOS users).
- **`.zip`** — Windows-friendly mirror archives.
- **`.csv`** — plain CSV (rare, uncompressed).

The ingest pipeline automatically detects and supports all three.

## Cache Behavior

- Archives are staged in a local cache directory (`.cache/wspr` by default).
- Each file is named `wsprspots-YYYY-MM.csv.gz` (or `.zip`, `.csv`).
- On repeated runs, cached files are reused unless explicitly removed.

## Usage Examples

Download + ingest July 2014 into a DuckDB file:

```bash
wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb
```

Stage archives only (without ingest):

```bash
wspr-ai-lite fetch --from 2014-01 --to 2014-12 --cache .cache/wspr
```

This requires that the .csv.gz / .zip / .csv files already exist in the cache.

## Internals
- Archives are normalized into the canonical WSPR schema defined in docs/schema.md.
- The pipeline enforces:
- UTC timestamps
- Uppercased callsigns and grids
- Canonical band_code derived from frequency
- Robust handling of missing fields in older archives
