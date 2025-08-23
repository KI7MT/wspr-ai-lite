"""
Expanded tests for pipelines.ingest:
- archive_url, month_range, band_from_freq_mhz
- read_month_csv with mixed/invalid rows
- download_month cache behavior
- update_cache_history + clean_all_cached
- ingest_month end-to-end insert into DuckDB
"""
import io
import gzip
import json
import duckdb
import pytest

from pipelines.ingest import (
    month_range,
    archive_url,
    band_from_freq_mhz,
    read_month_csv,
    update_cache_history,
    clean_all_cached,
    ingest_month,
)

def _make_gz_bytes(rows):
    csv = "\n".join(",".join(map(str, r)) for r in rows).encode()
    buf = io.BytesIO()
    with gzip.GzipFile(fileobj=buf, mode="wb") as gz:
        gz.write(csv)
    return buf.getvalue()

def test_archive_url():
    assert archive_url(2014, 7).endswith("wsprspots-2014-07.csv.gz")


def test_month_range_spans_year():
    assert month_range("2014-11", "2015-02") == [(2014,11),(2014,12),(2015,1),(2015,2)]


def test_band_from_freq_basic():
    assert band_from_freq_mhz(14.0956) == 20
    assert band_from_freq_mhz(7.0386) == 40


def test_read_month_csv_mixed_rows():
    good = [
        [0, 1404172800, "KD0HFC", "EN24qo", -22, 14.097077, "AE7CD", "EM12pt"],
        [0, 1404172860, "K1JT",   "FN20qi", -18, 7.038600,  "KI7MT", "DN45fo"],
    ]
    bad = [
        [0, "", "BAD", "----", "", "", "", ""],
        [0, 1404172865, "XX", "AA00aa", -33, "", "YY", "BB00bb"],
    ]
    buf = io.BytesIO("\n".join(",".join(map(str, r)) for r in (good + bad)).encode())
    df = read_month_csv(buf)
    assert len(df) == 2
    assert "ts" in df.columns


def test_download_month_and_ingest(tmp_path):
    cache_dir = tmp_path / ".cache"
    cache_dir.mkdir()
    gz = cache_dir / "wsprspots-2014-07.csv.gz"
    rows = [
        [0, 1404172800, "KD0HFC", "EN24qo", -22, 14.097077, "AE7CD", "EM12pt"],
    ]
    gz.write_bytes(_make_gz_bytes(rows))

    con = duckdb.connect(str(tmp_path / "wspr.duckdb"))
    ingest_month(con, 2014, 7, str(cache_dir))
    cnt = con.execute("SELECT COUNT(*) FROM spots").fetchone()[0]
    assert cnt == 1

def test_cache_history_and_clean(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    d1 = tmp_path / ".cacheA"
    d2 = tmp_path / ".cacheB"
    d1.mkdir()
    d2.mkdir()
    update_cache_history(str(d1))
    update_cache_history(str(d2))

    data = json.load(open(".cache_history.json"))
    # update_cache_history stores absolute paths; assert on those
    assert str(d1) in data["dirs"]
    assert str(d2) in data["dirs"]

    clean_all_cached()
    assert not d1.exists()
    assert not d2.exists()
