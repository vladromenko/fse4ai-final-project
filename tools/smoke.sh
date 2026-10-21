#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/fse4ai-smoke.XXXXXX")"
BUILD_VENV="$WORK_DIR/build-venv"
TRY_VENV="$WORK_DIR/try-venv"

trap 'rm -rf "$WORK_DIR"' EXIT

cd "$ROOT_DIR"

python3 -m venv "$BUILD_VENV" &&

"$BUILD_VENV/bin/python" -m pip install --upgrade pip wheel &&

"$BUILD_VENV/bin/python" -m pip install \
    torch \
    --index-url https://download.pytorch.org/whl/cpu &&

mkdir -p dist &&

find dist -maxdepth 1 -type f -name '*.whl' -delete &&

"$BUILD_VENV/bin/python" -m pip wheel \
    . \
    --no-deps \
    --no-build-isolation \
    --wheel-dir dist &&

ls dist/*.whl | grep linux &&

python3 -m venv "$TRY_VENV" &&

"$TRY_VENV/bin/python" -m pip install --upgrade pip &&

"$TRY_VENV/bin/python" -m pip install \
    torch \
    --index-url https://download.pytorch.org/whl/cpu &&

"$TRY_VENV/bin/python" -m pip install dist/*.whl &&

cd /tmp &&

"$TRY_VENV/bin/python" -c '
import torch
from fse_ops import shifted_relu

x = torch.tensor([-2.0, 0.0, 1.0, 2.0], dtype=torch.float32)
result = shifted_relu(x)

assert result.device.type == "cpu"
assert result.dtype == torch.float32
assert torch.equal(result, torch.relu(x - 1))

print(result)
' &&

echo "OK"