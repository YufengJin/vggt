#!/bin/bash
set -e

source /root/.bashrc 2>/dev/null || true
export PATH="/opt/conda/envs/${ENV_NAME:-py310}/bin:$PATH"

cd /workspace

if [[ -f pyproject.toml || -f setup.py ]]; then
  micromamba run -n "${ENV_NAME:-py310}" pip install -e .
fi

if [[ $# -gt 0 ]]; then
  exec "$@"
else
  exec bash -l
fi
