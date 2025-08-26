# ===================================================================
# Makefile for wspr-ai-lite
# ===================================================================

PKG_NAME      ?= wspr-ai-lite

PY      := python3
VENV    := .venv
ACT     := . $(VENV)/bin/activate
PIP     := $(PY) -m pip

# ---- Version (resolve at make invocation) ----
VERSION := $(shell $(PY) -c "import tomllib, pathlib; print(tomllib.loads(pathlib.Path('pyproject.toml').read_text(encoding='utf-8'))['project']['version'])")

# ---- Defaults for app workflows (override at call site) ----
FROM ?= 2014-07
TO   ?= 2014-07
DB   ?= data/wspr.duckdb
PORT ?= 8501

# ---- Smoke-test vars ----
SMOKE_VENV ?= .smoke-venv
SMOKE_TMP  ?= .smoke-tmp
SMOKE_DB   ?= $(SMOKE_TMP)/wspr.duckdb
SMOKE_PY   := $(SMOKE_VENV)/bin/python
SMOKE_PIP  := $(SMOKE_VENV)/bin/pip
SMOKE_CLI  := $(SMOKE_VENV)/bin/wspr-ai-lite
SMOKE_MONTH ?= 2014-07

# -------------------------------------------------------------------
# Colors (POSIX-friendly, use with: echo -e $(C_Y)"text"$(C_NC))
# -------------------------------------------------------------------
C_R  := '\033[01;31m'   # red
C_G  := '\033[01;32m'   # green
C_Y  := '\033[01;33m'   # yellow
C_C  := '\033[01;36m'   # cyan
C_NC := '\033[01;37m'   # no color

.PHONY: help setup-dev venv install install-dev dev-install ingest ui run quickstart reset-db \
        build publish publish-test test lint-docs precommit-install clean distclean reset \
        docs-check-macros docs-serve smoke-test smoke-clean smoke-build smoke-install \
        smoke-ingest smoke-verify smoke-ui-check dist-clean-all smoke-test-pypi

help:
	@echo ''
	@echo -e $(C_C)'wspr-ai-lite — Developer Commands'$(C_NC)
	@echo   '-------------------------------------------------------------------------------'
	@echo -e $(C_Y)'Defaults:'$(C_NC) 'FROM='$(FROM) 'TO='$(TO) 'DB='$(DB) 'PORT='$(PORT) 'VERSION='$(VERSION)
	@echo   ''
	@grep -E '^[a-zA-Z0-9_.-]+:.*?##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'
	@echo   ''

# ---- Dev env & installs ------------------------------------------------------

setup-dev: venv ## Create venv, install dev+docs deps, install pre-commit hooks
	@$(ACT); $(PIP) install --upgrade pip
	@$(ACT); $(PIP) install -r requirements.txt
	@$(ACT); $(PIP) install -r requirements-dev.txt
	@$(ACT); if [ -f requirements-docs.txt ]; then $(PIP) install -r requirements-docs.txt; fi
	@$(ACT); pre-commit install --hook-type pre-commit
	@$(ACT); pre-commit install --hook-type commit-msg
	@echo ''
	@echo "Dev environment ready."
	@echo "Hooks installed: pre-commit + commit-msg (Commitizen)."
	@echo ''

venv: ## Create Python virtual environment (.venv)
	@test -d $(VENV) || ($(PY) -m venv $(VENV) && echo "Created $(VENV)")

install: ## Install runtime dependencies (requirements.txt)
	@$(ACT); $(PIP) install --upgrade pip
	@$(ACT); $(PIP) install -r requirements.txt

install-dev: ## Install dev dependencies (requirements-dev.txt)
	@$(ACT); $(PIP) install --upgrade pip
	@$(ACT); $(PIP) install -r requirements-dev.txt

dev-install: ## Install package in editable mode (`pip install -e .`)
	@$(ACT); $(PIP) install -e .

# ---- App workflows -----------------------------------------------------------

ingest: ## Ingest WSPR data (vars: FROM, TO, DB)
	@set -e; \
	FROM="$(FROM)"; TO="$(TO)"; DB="$(DB)"; \
	: "$${FROM:?FROM required}" "$${TO:?TO required}" "$${DB:?DB required}"; \
	echo -e $(C_Y)"[ingest] FROM=$$FROM TO=$$TO DB=$$DB"$(C_NC); \
	$(ACT); wspr-ai-lite ingest --from "$$FROM" --to "$$TO" --db "$$DB"

ui: ## Launch the Streamlit UI (vars: DB, PORT)
	@set -e; \
	DB="$(DB)"; PORT="$(PORT)"; \
	: "$${DB:?DB required}" "$${PORT:?PORT required}"; \
	echo -e $(C_Y)"[ui] DB=$$DB PORT=$$PORT"$(C_NC); \
	$(ACT); wspr-ai-lite ui --db "$$DB" --port "$$PORT"

run: ui ## Alias for `ui`

quickstart: ## dev-install → ingest (FROM/TO/DB) → ui (PORT)
	@echo -e $(C_C)"[quickstart] VERSION=$(VERSION) FROM=$(FROM) TO=$(TO) DB=$(DB) PORT=$(PORT)"$(C_NC)
	@$(MAKE) dev-install
	@$(MAKE) ingest FROM="$(FROM)" TO="$(TO)" DB="$(DB)"
	@$(MAKE) ui DB="$(DB)" PORT="$(PORT)"

reset-db: ## Remove the current DuckDB file (uses DB var)
	@rm -f "$(DB)"
	@echo -e $(C_G)"Removed $(DB)"$(C_NC)

# ---- Packaging helpers (manual) ---------------------------------------------

build: ## Build wheel+sdist
	@$(ACT); python -m pip install --upgrade pip build
	@$(ACT); python -m build

publish-test: ## Upload to TestPyPI (manual)
	@$(ACT); python -m pip install --upgrade build twine
	@$(ACT); python -m build
	@$(ACT); python -m twine upload --repository testpypi dist/*

publish: ## Upload to PyPI (manual)
	@$(ACT); python -m pip install --upgrade build twine
	@$(ACT); python -m build
	@$(ACT); python -m twine upload dist/*

# ---- Tests & checks ----------------------------------------------------------

test: ## Run pytest
	@$(ACT); PYTHONPATH=. pytest -q

lint-docs: ## Docstring checks: coverage (interrogate) + pydocstyle
	@$(ACT); interrogate -i -v -m -p -r src pipelines tests | sed 's/^/interrogate: /'
	@$(ACT); pydocstyle src pipelines tests || true

precommit-install: ## Install git pre-commit hooks
	@$(ACT); pre-commit install

# ---- Cleaning ----------------------------------------------------------------

clean: ## Clean temporary files, caches, local DBs, and MkDocs site/
	@find . -name "__pycache__" -type d -prune -exec rm -rf {} \; || true
	@rm -rf .pytest_cache .cache .cache_* || true
	@rm -f .cache_history.json || true
	@rm -f data/*.duckdb data/*.duckdb-wal || true
	@rm -rf htmlcov .coverage site || true
	@echo -e $(C_G)"Clean complete."$(C_NC)

distclean: clean ## Thorough clean: includes venv, dist, temp dirs
	@rm -rf $(VENV) .streamlit *.tar.gz *.zip tmp temp .smoke-tmp dist/
	@echo -e $(C_G)"Dist-clean complete."$(C_NC)

reset: distclean ## Full reset: distclean + recreate venv + install deps + ingest sample
	@$(PY) -m venv $(VENV)
	@$(ACT); $(PIP) install --upgrade pip
	@$(ACT); $(PIP) install -r requirements.txt
	@$(ACT); wspr-ai-lite ingest --from 2014-07 --to 2014-07 --db data/wspr.duckdb
	@echo -e $(C_G)"Reset complete. Run: make ui"$(C_NC)

# ---- Docs --------------------------------------------------------------------

docs-check-macros: ## Verify wspr_macros import path
	@PYTHONPATH=docs/_ext python -c "import importlib.util; print('wspr_macros importable:', importlib.util.find_spec('wspr_macros') is not None)"

docs-serve: ## Serve docs locally with MkDocs (auto-reloads on changes)
	@echo -e $(C_Y)"[docs] VERSION=$(VERSION)"$(C_NC)
	@WSPR_AI_LITE_VERSION=$(VERSION) PYTHONPATH=docs/_ext mkdocs serve

# ---- Smoke tests (end-to-end) ------------------------------------------------

# Run the wiring audit before everything else
smoke-test: audit-cli-wiring smoke-clean smoke-build smoke-install smoke-ingest smoke-verify smoke-ui-check ## Full end-to-end smoke test

smoke-build: ## Build wheel+sdist for smoke test
	@python -m pip install --disable-pip-version-check --upgrade pip build >/dev/null
	@python -m build
	@ls -1 dist/$(subst -,_,$(PKG_NAME))* 1>/dev/null
	@echo "[smoke] build: OK"

smoke-install: ## Create isolated smoke venv and install the built wheel
	@rm -rf $(SMOKE_VENV) $(SMOKE_TMP) && mkdir -p $(SMOKE_TMP)
	@python -m venv $(SMOKE_VENV)
	@$(SMOKE_PIP) install --upgrade pip >/dev/null
	@$(SMOKE_PIP) install dist/$(subst -,_,$(PKG_NAME))*whl >/dev/null
	@$(SMOKE_CLI) --version || true
	@echo "[smoke] install: OK"

smoke-ingest: ## Ingest a single month into a temporary DuckDB
	@mkdir -p $(SMOKE_TMP)
	@$(SMOKE_CLI) ingest --from $(SMOKE_MONTH) --to $(SMOKE_MONTH) --db $(SMOKE_DB)
	@echo "[smoke] ingest: OK"

smoke-verify: ## Verify the DuckDB contains rows
	@$(SMOKE_PY) -c "import duckdb, os, sys; db=os.environ.get('DB','$(SMOKE_DB)'); con=duckdb.connect(db, read_only=True); cnt=con.execute('SELECT COUNT(*) FROM spots').fetchone()[0]; print(f'[smoke] rows: {cnt}'); sys.exit(0 if cnt>0 else 2)"
	@echo "[smoke] verify: OK"

smoke-ui-check: ## Check UI presence and streamlit availability
	@$(SMOKE_PY) -c "import importlib, pathlib, wspr_ai_lite; p=pathlib.Path(wspr_ai_lite.__file__).with_name('wspr_ai_lite.py'); assert p.exists(), f'wspr_ai_lite.py missing at {p}'; importlib.import_module('streamlit'); print('[smoke] ui-check: app present & streamlit import OK')"
	@echo "[smoke] ui-check: OK"

smoke-clean: ## Remove smoke-test artifacts (venv + tmp DB)
	@rm -rf $(SMOKE_VENV) $(SMOKE_TMP)
	@echo "[smoke] clean: OK"

dist-clean-all: distclean ## Deep clean + remove smoke artifacts
	@rm -rf .smoke-venv .smoke-tmp
	@echo "dist-clean-all: also removed smoke artifacts."

smoke-test-pypi: smoke-clean ## Install from PyPI and run verify+ui-check
	@python -m venv $(SMOKE_VENV)
	@$(SMOKE_PIP) install --upgrade pip >/dev/null
	@$(SMOKE_PIP) install "wspr-ai-lite==$(VERSION)"
	@mkdir -p $(SMOKE_TMP)
	@$(SMOKE_CLI) ingest --from $(SMOKE_MONTH) --to $(SMOKE_MONTH) --db $(SMOKE_DB)
	@$(SMOKE_PY) -c "import duckdb,sys; con=duckdb.connect('$(SMOKE_DB)', read_only=True); cnt=con.execute('SELECT COUNT(*) FROM spots').fetchone()[0]; print(f'[smoke] rows: {cnt}'); sys.exit(0 if cnt>0 else 2)"
	@$(SMOKE_PY) -c "import importlib, pathlib, wspr_ai_lite; p=pathlib.Path(wspr_ai_lite.__file__).with_name('wspr_ai_lite.py'); assert p.exists(), f'wspr_ai_lite.py missing at {p}'; importlib.import_module('streamlit'); print('[smoke] ui-check: app present & streamlit import OK')"
	@echo "[smoke] PyPI smoke: OK"

.PHONY: db-views
db-views: ## Create/refresh computed views (spots_v)
	@$(ACT); $(PY) scripts/create_views.py --db $(DB)


.PHONY: audit-cli-wiring
audit-cli-wiring: ## Check for stray Click decorators in
	@echo "[audit] checking for stray Click decorators in libs..."
	@! grep -Rnw src/wspr_ai_lite -e '@cli\.command' -e '@click\.command' -e '@click\.group' \
	  | grep -vE '(cli\.py|tools\.py|mcp/server\.py|fetch\.py)' || \
	  (echo "Found stray CLI decorators in library modules"; exit 1)
	@echo "[audit] checking for __main__ blocks in libs..."
	@! grep -Rnw src/wspr_ai_lite -e '__name__\s*==\s*["'\'']__main__["'\'']' \
	  | grep -vE '(cli\.py|tools\.py|mcp/server\.py|fetch\.py)' || \
	  (echo "Found __main__ entrypoints in library modules"; exit 1)
	@echo "[audit] OK"
