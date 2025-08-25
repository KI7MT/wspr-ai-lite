"""
Project-specific macros for MkDocs (mkdocs-macros-plugin).
Used in Markdown like:
  - Build time: {{ build_time() }}
  - Version: {{ config.extra.version | default("dev") }}
"""
import os
from datetime import datetime, UTC

def define_env(env):
    # Read version from env (set in Makefile/CI); fall back to "dev"
    version = os.environ.get("WSPR_AI_LITE_VERSION", "dev")

    # Ensure config.extra exists, then set version for templates:
    env.conf.setdefault("extra", {})
    env.conf["extra"]["version"] = version

    # Simple build timestamp macro
    env.macro(lambda: datetime.now(UTC).isoformat(timespec="seconds"), name="build_time")

def on_post_build(_plugin) -> None:
    """
    Called after the site is built. We just log the version that MkDocs
    also reads via !ENV to avoid reaching into plugin internals.
    """
    import os
    v = os.environ.get("WSPR_AI_LITE_VERSION", "dev")
    print(f"[macros] post_build: version={v}")
