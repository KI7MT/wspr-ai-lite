from __future__ import annotations

"""Console entrypoint for wspr-ai-lite.

Subcommands:
- `fetch`  : Download monthly WSPRNet archives into a cache directory.
- `ingest` : Parse staged (or freshly downloaded) archives and insert into DuckDB.
- `ui`     : Launch the Streamlit dashboard that reads from the DuckDB file.

Usage examples:
    wspr-ai-lite fetch --from 2014-07 --to 2014-09 --cache .cache
    wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb --cache .cache
    wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb --offline
    wspr-ai-lite ui --db data/wspr.duckdb --port 8501
"""

import os
import subprocess
import sys
from pathlib import Path

import click
import duckdb

from . import __version__
from .ingest import ingest_month, month_range, download_month


@click.group(context_settings={"help_option_names": ["-h", "--help"]})
@click.version_option(version=__version__, prog_name="wspr-ai-lite")
def main() -> None:
    """WSPR AI Lite utilities (CLI)."""
    pass


# -----------------------------
# fetch
# -----------------------------
@main.command()
@click.option("--from", "start", required=True, help="Start month (YYYY-MM)")
@click.option("--to", "end", required=True, help="End month (YYYY-MM)")
@click.option("--cache", type=click.Path(path_type=Path), default=Path(".cache"), show_default=True, help="Cache directory")
@click.option("--force", is_flag=True, default=False, help="Re-download even if file exists")
def fetch(start: str, end: str, cache: Path, force: bool) -> None:
    """Download monthly .csv.gz archives into a cache directory."""
    cache.mkdir(parents=True, exist_ok=True)

    downloaded = 0
    for y, m in month_range(start, end):
        gz_path = cache / f"wsprspots-{y:04d}-{m:02d}.csv.gz"
        if force and gz_path.exists():
            try:
                gz_path.unlink()
            except OSError:
                pass
        download_month(y, m, cache_dir=cache)
        click.echo(f"[staged] {gz_path}")
        downloaded += 1

    click.secho(f"[done] staged {downloaded} file(s) in {cache}", fg="green")


# -----------------------------
# ingest
# -----------------------------
@main.command()
@click.option("--from", "start", required=True, help="Start month (YYYY-MM)")
@click.option("--to", "end", required=True, help="End month (YYYY-MM)")
@click.option("--db", type=click.Path(path_type=Path), default=Path("data/wspr.duckdb"), show_default=True, help="DuckDB path")
@click.option("--cache", type=click.Path(path_type=Path), default=Path(".cache"), show_default=True, help="Cache directory")
@click.option("--offline", is_flag=True, default=False, help="Read only from cache (no network)")
def ingest(start: str, end: str, db: Path, cache: Path, offline: bool) -> None:
    """Ingest one or more months into DuckDB (canonical schema)."""
    db.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(db))

    total = 0
    for y, m in month_range(start, end):
        total += ingest_month(con, y, m, cache_dir=cache, offline=offline)

    click.secho(f"[OK] inserted rows: {total}", fg="green")


# -----------------------------
# ui
# -----------------------------
def _app_path() -> Path:
    """Resolve the Streamlit app path (packaged first, then dev fallback)."""
    packaged = Path(__file__).with_name("wspr_ai_lite.py")
    if packaged.exists():
        return packaged
    return Path(__file__).resolve().parents[2] / "app" / "wspr_ai_lite.py"


@main.command()
@click.option("--db", type=click.Path(path_type=Path), default=Path("data/wspr.duckdb"), show_default=True, help="DuckDB path")
@click.option("--port", type=int, default=8501, show_default=True, help="Streamlit port")
def ui(db: Path, port: int) -> None:
    """Run Streamlit UI."""
    app_path = _app_path()
    if not app_path.exists():
        click.secho(
            f"ERROR: Cannot find Streamlit app at {app_path}\n"
            "This likely means the package app file was not included in the install.",
            fg="red",
            err=True,
        )
        sys.exit(1)

    env = os.environ.copy()
    if db:
        env["WSPR_DB_PATH"] = str(db)

    try:
        code = subprocess.call(
            [sys.executable, "-m", "streamlit", "run", str(app_path), "--server.port", str(port)],
            env=env,
        )
    except ModuleNotFoundError:
        click.secho(
            "ERROR: Streamlit is not installed in this environment.\n"
            "Install it with:\n\n    pip install streamlit\n",
            fg="red",
            err=True,
        )
        sys.exit(1)

    sys.exit(code)


# -----------------------------
# Deprecated alias
# -----------------------------
def deprecated_entrypoint() -> None:
    """Shim for old command name."""
    click.secho(
        "WARNING: The `wspr-lite` entrypoint is deprecated.\n"
        "Please use the new command: `wspr-ai-lite`.\n",
        fg="yellow",
    )
    main()


if __name__ == "__main__":
    main()
