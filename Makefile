# Makefile for wspr-ai-lite
# Common developer shortcuts. All commands are explicit and documented.

PY := python3
PIP := pip
VENV := .venv
ACT := . $(VENV)/bin/activate

.PHONY: help setup-dev venv install run ingest test clean

help:
	@clear
	@echo
	@echo "Make targets:"
	@echo "  setup-dev   Create venv and install dependencies"
	@echo "  venv        Create Python virtual environment (.venv)"
	@echo "  install     Install dependencies (requires venv active)"
	@echo "  run         Run Streamlit UI"
	@echo "  ingest      Ingest a sample month (2014-07)"
	@echo "  test        Run pytest"
	@echo "  clean       Remove caches and __pycache__"
	@echo "  distclean   Clean repo before sending to version ocontrol"
	@echo

setup-dev: venv
	@$(ACT); $(PIP) install -r requirements.txt
	@echo "Dev environment ready."

venv:
	@test -d $(VENV) || ($(PY) -m venv $(VENV) && echo "Created $(VENV)")

install:
	@$(ACT); $(PIP) install -r requirements.txt

run:
	@$(ACT); streamlit run app/wspr_app.py

ingest:
	@$(ACT); $(PY) pipelines/ingest.py --from 2014-07 --to 2014-07

test:
	@$(ACT); pytest -q

clean:
	@find . -name "__pycache__" -type d -prune -exec rm -rf {} \; || true
	@rm -rf .pytest_cache .cache .cache_* || true
	@rm -f .cache_history.json || true
	@rm -f data/*.duckdb data/*.duckdb-wal || true
	@rm -rf htmlcov .coverage || true
	@echo "Clean complete."

distclean: clean
	@rm -rf .venv || true
	@rm -rf .streamlit || true
	@rm -rf *.tar.gz *.zip || true
	@rm -rf tmp temp || true
	@echo "Dist-clean complete (venv, temp files, archives removed)."
