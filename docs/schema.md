# Canonical WSPR "spots" Schema

This document defines the **authoritative schema** for WSPR (Weak Signal Propagation Reporter) data
within **wspr-ai-lite**. All code, database models, and downstream integrations must conform to this schema.

## Purpose

- Provide a **single source of truth** for the `spots` table.
- Ensure consistency across storage backends (DuckDB, ClickHouse, future).
- Define clear semantics for each field, including units and valid ranges.
- Act as the base contract for MCP tool manifests.

---

## Table: `spots`

| Column             | Type        | Description                                                                                |
|--------------------|------------|---------------------------------------------------------------------------------------------|
| `spot_id`          | BIGINT     | Unique integer spot identifier (PK). Not contiguous; gaps expected.                         |
| `timestamp`        | TIMESTAMP  | UTC timestamp (from UNIX epoch seconds).                                                    |
| `reporter`         | VARCHAR(10)| RX callsign (or SWL identifier). Uppercased.                                                |
| `reporter_grid`    | VARCHAR(6) | Maidenhead grid of reporting station (4 or 6 char).                                         |
| `snr_db`           | SMALLINT   | Signal-to-noise ratio in dB (WSPR spec: -30..+20 typical).                                  |
| `freq_mhz`         | DOUBLE     | Frequency of received signal, MHz with fractional precision.                                |
| `tx_call`          | VARCHAR(10)| TX callsign. May omit portable designators (legacy WSPR encoding limitation).               |
| `tx_grid`          | VARCHAR(6) | Maidenhead grid of TX station.                                                              |
| `power_dbm`        | SMALLINT   | Transmitter power in dBm (0..50 typical, but may be <0 for <1mW).                           |
| `drift_hz_per_min` | SMALLINT   | Measured drift in Hz/minute (-3..+3 typical).                                               |
| `distance_km`      | INTEGER    | Great-circle distance between TX/RX, km.                                                    |
| `azimuth_deg`      | SMALLINT   | Great-circle azimuth (direction TX → RX), degrees (0–359).                                  |
| `band_code`        | SMALLINT   | Band index: -1=LF, 0=MF, 1=160m, 3=80m, 5=60m, 7=40m, 10=30m, etc.                          |
| `rx_version`       | VARCHAR    | Version string of RX software (may be empty in older data).                                 |
| `code`             | INTEGER    | Error code: `0` = valid, >0 indicates possible bogus spot (wrong band, callsign, etc.).     |

---

## Notes

- **Primary Key**: `spot_id`. Not guaranteed sequential; enforce uniqueness only.
- **Time semantics**: Always stored in UTC; ISO-8601 format for interchange.
- **Case handling**: Callsigns normalized to uppercase at ingest.
- **Cross-DB Compatibility**: Schema applies to both **DuckDB** and **ClickHouse**, with backend-specific type adjustments.
- **Indexes (recommended)**:
  - `timestamp` (range queries)
  - `(reporter, tx_call)` (per-station analysis)
  - `band_code` (band lookups)

---

## Example Record

```json
{
  "spot_id": 123456789,
  "timestamp": "2014-07-01T00:02:12Z",
  "reporter": "KI7MT",
  "reporter_grid": "CN87",
  "snr_db": -19,
  "freq_mhz": 14.097123,
  "tx_call": "W1AW",
  "tx_grid": "FN31",
  "power_dbm": 37,
  "drift_hz_per_min": 1,
  "distance_km": 3824,
  "azimuth_deg": 65,
  "band_code": 14,
  "rx_version": "wspr-2.0",
  "code": 0
}
```
