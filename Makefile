# ===================================================================
# Makefile for wspr-ai-lite
# -------------------------------------------------------------------
# Provides common developer shortcuts:
#   - Environment setup (venv, dependencies)
#   - Running the app
#   - Ingesting WSPR data
#   - Testing
#   - Cleaning and resetting the project
#
# Usage:
#   make <target>
# Example:
#   make setup-dev   # Create venv + install dependencies
#   make run         # Launch Streamlit UI
#   make reset       # Clean EVERYTHING and rebuild fresh
# ===================================================================

PY      := python3
PIP     := pip
VENV    := .venv
ACT     := . $(VENV)/bin/activate

.PHONY: help setup-dev venv install run ingest test clean distclean reset

# -------------------------------------------------------------------
# Show available commands
# -------------------------------------------------------------------
help:
	@echo "Available make targets:"
	@echo "  setup-dev   Create venv and install dependencies"
	@echo "  venv        Create Python virtual environment (.venv)"
	@echo "  install     Install dependencies (requires venv active)"
	@echo "  run         Run Streamlit UI"
	@echo "  ingest      Ingest a sample month (2014-07)"
	@echo "  test        Run pytest"
	@echo "  clean       Remove caches, __pycache__, test artifacts, local DB"
	@echo "  distclean   clean + remove venv, temp, packaging artifacts"
	@echo "  reset       distclean + recreate venv + install + sample ingest"

# -------------------------------------------------------------------
# Development setup: create venv and install requirements
# -------------------------------------------------------------------
setup-dev: venv
	@$(ACT); $(PIP) install --upgrade pip
	@$(ACT); $(PIP) install -r requirements.txt
	@echo "Dev environment ready."

# -------------------------------------------------------------------
# Create Python virtual environment if missing
# -------------------------------------------------------------------
venv:
	@test -d $(VENV) || ($(PY) -m venv $(VENV) && echo "Created $(VENV)")

# -------------------------------------------------------------------
# Install dependencies into the existing venv
# -------------------------------------------------------------------
install:
	@$(ACT); $(PIP) install --upgrade pip
	@$(ACT); $(PIP) install -r requirements.txt

# -------------------------------------------------------------------
# Run Streamlit dashboard
# -------------------------------------------------------------------
run:
	@$(ACT); streamlit run app/wspr_app.py

# -------------------------------------------------------------------
# Ingest a sample month of WSPR data (2014-07 by default)
# -------------------------------------------------------------------
ingest:
	@$(ACT); $(PY) pipelines/ingest.py --from 2014-07 --to 2014-07

# -------------------------------------------------------------------
# Run the test suite (pytest, with PYTHONPATH set for discovery)
# -------------------------------------------------------------------
test:
	@$(ACT); PYTHONPATH=. pytest -q

# -------------------------------------------------------------------
# Clean temporary files, caches, and local DBs
# -------------------------------------------------------------------
clean:
	@find . -name "__pycache__" -type d -prune -exec rm -rf {} \; || true
	@rm -rf .pytest_cache .cache .cache_* || true
	@rm -f .cache_history.json || true
	@rm -f data/*.duckdb data/*.duckdb-wal || true
	@rm -rf htmlcov .coverage || true
	@echo "Clean complete."

# -------------------------------------------------------------------
# More thorough clean: includes venv, packaging artifacts, temp dirs
# -------------------------------------------------------------------
distclean: clean
	@rm -rf $(VENV) || true
	@rm -rf .streamlit || true
	@rm -rf *.tar.gz *.zip || true
	@rm -rf tmp temp || true
	@echo "Dist-clean complete (venv, temp files, archives removed)."

# -------------------------------------------------------------------
# Full reset: distclean + recreate venv + install deps + ingest sample
# -------------------------------------------------------------------
reset: distclean
	@$(PY) -m venv $(VENV)
	@$(ACT); $(PIP) install --upgrade pip
	@$(ACT); $(PIP) install -r requirements.txt
	@$(ACT); $(PY) pipelines/ingest.py --from 2014-07 --to 2014-07
	@echo "Reset complete. Run: make run"
# Docs tasks (MkDocs)
docs-serve:
	mkdocs serve

docs-deploy:
	mkdocs gh-deploy --force
