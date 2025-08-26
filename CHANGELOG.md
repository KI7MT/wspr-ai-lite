# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Consolidated roadmap documents:
  - Merged `Roadmap-v0.4.0.md` into the canonical `ROADMAP.md`.
  - Removed duplicate file to maintain a single source of truth for project planning.

## [0.3.7] - 2025-08-25

### Changed
- Consolidated roadmap documents:
- Merged `Roadmap-v0.4.0.md` into the canonical `ROADMAP.md`.
- Removed duplicate file to maintain a single source of truth for project planning.

## [0.3.7] - 2025-08-25
### Fixed
- **Cross-platform ingestion**
  Ingest pipeline now transparently handles:
  - `*.csv.gz` archives (Linux/macOS default on wsprnet.org)
  - `*.zip` archives (needed for Windows users / alt mirrors)
  - raw `*.csv` (uncompressed) files if present

  This ensures a consistent workflow for all platforms:
  ```bash
  wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb
  ```

  Works the same whether the archive is gzipped, zipped, or plain CSV.

Documentation
- Added docs/ingest.md describing ingestion pipeline, caching, offline usage, and archive format support.
- Updated schema doc with note that ingestion supports .gz, .zip, or .csv transparently.

---

[0.3.7]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.3.6...v0.3.7

## [0.3.6] - 2025-08-25
### Chaangd
- Fixed versioning for release as local script failed to update properly.
- No other changes form v0.3.4 to 0.3.6

[0.3.4]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.3.4...v0.3.6


## [0.3.4] - 2025-08-25

### Added
- **Canonical WSPR Schema**
  - Added `docs/schema.md` as the single source of truth for all `spots` fields.
  - Normalized columns (`spot_id`, `timestamp`, `reporter`, `reporter_grid`, `snr_db`, `freq_mhz`, `tx_call`, `tx_grid`, `power_dbm`, `drift_hz_per_min`, `distance_km`, `azimuth_deg`, `band_code`, `rx_version`, `code`).

- **Ingest pipeline updates**
  - Refactored `ingest.py` to parse monthly archives directly into the canonical schema.
  - Added `band_code_from_freq_mhz()` (int-based band codes) alongside legacy `band_from_freq_mhz()`.
  - Added `load_month_bytes()` with `offline` option (use local `.gz` cache only).
  - Ensured consistent dtype casting and callsign normalization.

- **CLI updates (Click migration)**
  - Migrated `cli.py`, `ingest.py`, and `fetch.py` to use [Click](https://click.palletsprojects.com/) for cleaner CLI UX.
  - New `fetch` command: stage `.csv.gz` archives into a local cache for later ingestion.
  - Consistent `--from/--to/--db/--cache` options across CLI commands.

- **Database tools CLI**
  - New `wspr-ai-lite-tools` utility for DB management:
    - `stats` — summarize row counts, time range, distinct reporters/tx, and band codes.
    - `verify` — check schema against canonical WSPR `spots` schema, with `--strict` and `--explain`.
    - `migrate` — upgrade legacy/flat schemas to canonical format (with optional `--no-backup`).
  - Provides a base template for adding future DB utilities.

- **Database views**
  - Added script `scripts/create_views.py` and Makefile target `db-views`.
  - Provides a computed view `spots_v` with derived `year`, `month`, `hour`, and `band_label` columns for simplified queries.

- **MCP Foundations**
  - Introduced `src/wspr_ai_lite/mcp/manifest.json` defining safe, typed tools for accessing WSPR data.
  - Added `src/wspr_ai_lite/mcp/server.py` with Click entrypoint `wspr-ai-lite-mcp`.
  - Implements initial tools: `get_summary`, `query_spots`, `top_reporters`, `top_heard`, `band_activity`, `spot_by_id`.
  - Supports `--init` mode for creating the DB if missing.
  - Establishes contract-driven access (manifest defines, server implements).

### Changed
- **UI / Queries**
  - Updated Streamlit app queries to align with canonical schema (`snr_db`, `freq_mhz`, `tx_call`, etc.).
  - Replaced legacy `band` string usage with `band_code` + `band_label` view where appropriate.
  - Ensured reciprocal heard, distance/DX, and SNR trend panels use updated schema.

- **Makefile**
  - Cleaned duplicate/overlapping targets.
  - Added colorized help output and sane defaults for `DB`, `FROM`, `TO`, and `PORT`.
  - New `db-views` target to build/refresh computed views.

### Fixed
- Consistent uppercase normalization of callsigns and Maidenhead grids.
- Proper handling of missing/blank `rx_version` and `code` fields in older archives.
- DuckDB table creation now fully aligned with schema doc.

---

[0.3.4]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.3.3...v0.3.4


## [0.3.3] - 2025-08-25

### Fixed
- Removed deprecated license metadata (`project.license` as table + classifier).
  - Now using SPDX expression (`license = "MIT"`) and `license-files` in `pyproject.toml`.
  - Eliminates `SetuptoolsDeprecationWarning` during builds.
- Cleaned up Makefile targets with sensible defaults for `ingest`, `ui`, and `quickstart`.

### Improved
- Smoke tests now run cleanly without warnings.
- Packaging metadata fully compliant with future setuptools (>=77.0) requirements.

[0.3.3]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.3.2...v0.3.3

## [0.3.2] - 2025-08-25
### Fixed
- Corrected release workflow configuration:
  - Removed duplicate/unused GitHub Actions workflow (`action-gh-release.yml`)
  - Ensured `release.yml` is the single source for PyPI + GitHub Releases
- Addressed issues with tag handling and publishing sequence

### Notes
- This is a maintenance release to stabilize CI/CD before continuing new feature development.

---

[0.3.1]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.3.1...v0.3.2

## [0.3.1] - 2025-08-25
### Fixed
- Version tage had special charchter in it.

---

[0.3.0]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.3.0...v0.3.1

## [0.3.1] - 2025-08-25
### Fixed
- Corrected version string issue introduced in v0.3.0 (bad character in tag/pyproject).

### Changed
- Switched versioning to **single source of truth** in `pyproject.toml`.
- Improved GitHub Actions workflows:
  - Separated PyPI publishing (`release.yml`) from GitHub Release creation (`action-gh-release.yml`).
  - Verified tag-to-version consistency against `pyproject.toml`.
  - Added artifact sharing between jobs.
- Documentation:
  - Fixed **MkDocs macros import** (`wspr_macros`) for both local and CI builds.
  - Docs now correctly show `Current version: x.y.z` instead of `dev`.
  - Added environment-variable–based version injection (`extra.version`).

### Fixed
- Removed duplicate/unwanted PyPI publishing from `action-gh-release.yml`.
- Corrected missing README on PyPI by setting `readme = "README.md"` in `pyproject.toml`.

### Packaging
- Dependency metadata corrected in `pyproject.toml` (`duckdb`, `streamlit`, etc.).
- Classifiers updated for Python 3.11–3.13.
- Smoke tests now validate `duckdb` ingestion end-to-end.

---

[0.3.0]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.2.9...v0.3.0

## [0.2.9] - 2025-08-25

### Fixed
- Documentation build on CI: ensure local macros (`docs/_ext/wspr_macros`) are discoverable by adding `PYTHONPATH=docs/_ext`.
- Prevent `mkdocs-macros-plugin` from trying to `pip install wspr_macros`.

### Changed
- Bumped project version to `0.2.9` in `pyproject.toml` to realign tags, releases, and PyPI.

### Added
- Guard in CI workflow to sanity-check `wspr_macros` import before running MkDocs build.
- Confirmed docs version injection from `pyproject.toml` → GitHub Actions → MkDocs (`extra.version`) is working end-to-end.

---

[0.2.9]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.2.8...v0.2.9

## [0.2.8] - 2025-08-25

### Added
- GitHub Release automation:
- CI now auto-creates GitHub Releases on new tags.
- Release artifacts (.whl, .tar.gz) are attached automatically.
- Auto-generated release notes enabled.

### Changed
- CI/CD workflows: Refactored to enforce version consistency (pyproject.toml vs Git tag) before publishing.
- Documentation: MkDocs now consistently shows the correct version ({{ config.extra.version }} injected via environment).

---

[0.2.6]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.2.6...v0.2.8

### Fixed
	•	Removed dependency on scripts/get_version.py; version is now resolved directly from pyproject.toml.
	•	Fixed docs build issues caused by macros module import path handling.
  - Footer links (going forward, so GitHub auto-links diffs):

## [0.2.6] - 2025-08-24
### Fixed
- Declared required runtime dependencies (`duckdb`, `streamlit`, etc.) in `pyproject.toml`.
  This ensures the CLI works correctly after a fresh `pip install wspr-ai-lite` without missing imports.

### Improved
- Smoke tests now validate the PyPI wheel by running `wspr-ai-lite ingest` end-to-end,
  verifying dependency resolution and successful data ingestion.
- Documentation versioning refined to pull from `pyproject.toml`, reducing mismatch risk.

---

[0.2.6]: https://github.com/KI7MT/wspr-ai-lite/compare/v0.2.5...v0.2.6

## [0.2.6] - 2025-08-24
### Added
- **MkDocs macros integration**: Added `docs/_ext/wspr_macros` with build-time macros (project metadata, UTC build time).
- **CI Docs versioning**: GitHub Actions now injects `WSPR_AI_LITE_VERSION` into docs builds for reproducible version output.
- **GitHub Standards**: Added `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `.github` templates (issues + PR).

### Changed
- **Docs build pipeline**: Consolidated `make setup-dev` to install all requirements (runtime, dev, docs, pre-commit).
- **Makefile**: Removed brittle heredocs; simplified `docs-serve` and ensured environment injection for docs versioning.
- **Docs navigation**: Adjusted to fix broken references (`CHANGELOG.md`, `LICENSE.md`, etc.).

### Fixed
- **Smoke tests**: Updated `smoke-ui-check` to check for `wspr_ai_lite.py` instead of deprecated `wspr_app.py`.
- **Docs warnings**: Resolved strict build errors due to mismatched filenames and missing references.

## [0.2.5] - 2025-08-24
### Changed
- Fixes a missing link in documentation site

## [0.2.4] - 2025-08-24
### Changed
- Updated wspr_app.py entry point as the file moved from `app/wspr_app.py` to `srv/wspr_ai_lite/wspr_app.py`.
- Cleaned up Makefile to simplify help message.
- Removed docstrings from wspr_ai_lite.py to prevent rendering on landing page.
- Renamed the app entry point `wspr_app.py` to `wspr_ai_lite.py` to prevent potential WSPR app collisions.
- Updated Docs for new entry point `wspr-au-lite`
- Updated Developer documentation.

## [0.2.1] - 2025-08-24
### Changed
- CLI now displays the program name as `wspr-ai-lite` (instead of `wspr-lite`) in `--version` and help output.
- Updated documentation, usage examples, and CHANGELOG to consistently use `wspr-ai-lite` as the canonical command.
- Retained the `wspr-lite` shim for backward compatibility, which continues to emit a deprecation warning.

## [0.2.0] - 2025-08-24
### Changed
- Default CLI command is now `wspr-ai-lite`.
- Added transitional `wspr-ai-lite` shim with deprecation warning.

### Deprecated
- The `wspr-lite` command will be removed in a future release.

## [0.1.9] - 2025-08-24
### Fixed
- Added missing `import os` in `cli.py` (caused `wspr-ai-lite ui` to crash).
- Ensured module docstring placement is compliant with Python’s `__future__` import rules and pre-commit checks.

### Changed
- `wspr_app.py` is now packaged inside `wspr_ai_lite`, so `wspr-ai-lite ui` works out-of-the-box after `pip install`.
- CLI `ui` subcommand now correctly resolves the installed app path instead of referencing `app/wspr_app.py`.

### Notes
- Users can now launch the dashboard with:
  ```bash
  wspr-ai-lite ui --db ~/wspr-data/wspr.duckdb --port 8501

## [0.1.7] - 2025-08-23
### Fixed
- Fixed `wspr-ai-lite ingest` failures when running from the PyPI package:
- Removed dependency on repo-local `pipelines/` (ingest is now fully self-contained in the package).
- Corrected timestamp handling: UTC → naive UTC for DuckDB.
- Fixed DuckDB insert by using `con.register()` for DataFrame ingestion.
- Added Change log to site documents

### Changed
- Internal refactoring of ingest for better portability and reproducibility across platforms.

## [0.1.6] - 2025-08-23
### Added
- Initial PyPI release of `wspr-ai-lite`.
- CLI: `wspr-ai-lite ingest` for pulling and storing WSPRNet monthly archives into DuckDB.
- CLI: `wspr-ai-lite ui` for launching the Streamlit dashboard.
- Documentation site via MkDocs + Material theme.
- Pre-commit hooks and CI workflows for linting, testing, and publishing.

---

## [0.1.6] - 2025-08-23
### Fixed
- CI/CD release workflow using PyPI Trusted Publishing
- YAML syntax issues in `.github/workflows/release.yml`
- Unified single-source versioning via `__version__` in `src/wspr_ai_lite/__init__.py`

---

## [0.1.5] - 2025-08-22
### Added
- Initial PyPI publishing workflow with GitHub Actions
- Automatic version verification between Git tag and package version

---

## [0.1.0] - 2025-08-20
### Added
- First public release of `wspr-ai-lite`
- Ingest pipeline for WSPR CSV → DuckDB
- Streamlit dashboard for:
  - 📊 SNR distributions & monthly spot trends
  - 👂 Top reporters, most-heard TX stations
  - 🌍 Geographic spread & distance/DX analysis
  - 🔄 QSO-like reciprocal reports
  - ⏱ Hourly activity heatmaps & yearly unique counts
- Full developer docs with MkDocs + Material
- Pre-commit hooks & interrogate for docstring coverage
