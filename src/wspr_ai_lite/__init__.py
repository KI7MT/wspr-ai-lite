from __future__ import annotations

"""Top-level package for wspr-ai-lite utilities."""

# Single source of truth via setuptools-scm (Git tags).
# This tries importlib.metadata first (installed packages),
# then falls back to the file written by setuptools-scm during builds.

try:
    from importlib.metadata import version as _pkg_version  # Python 3.8+
except Exception:  # pragma: no cover
    _pkg_version = None  # type: ignore[assignment]

__all__ = ["__version__"]

def _read_version() -> str:
    # 1) When installed from wheel/sdist, metadata exists:
    if _pkg_version is not None:
        try:
            return _pkg_version("wspr-ai-lite")
        except Exception:
            pass
    # 2) During local editable dev builds, setuptools-scm writes this file:
    try:
        from ._version import version  # type: ignore
        return version
    except Exception:
        pass
    # 3) Fallback
    return "0.0.0+unknown"

__version__ = _read_version()
