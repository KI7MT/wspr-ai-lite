"""
Project-specific macros for MkDocs (mkdocs-macros-plugin).
Used in Markdown like:
  - Build time: {{ build_time() }}
  - Version: {{ config.extra.version | default("dev") }}
"""
from datetime import datetime, UTC

def define_env(env):
    """Register macros and variables for mkdocs-macros-plugin."""
    env.macro(lambda: datetime.now(UTC).isoformat(timespec="seconds"), name="build_time")
    env.variables["project"] = {
        "name": "wspr-ai-lite",
        "description": "Lightweight WSPR analytics dashboard (DuckDB + Streamlit)",
    }
