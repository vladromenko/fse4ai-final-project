# FSE4AI PyTorch Extension

This project provides a custom PyTorch C++ operation:

```python
fse_ops.shifted_relu
```

The operation subtracts one from every tensor element and then applies ReLU:

```python
torch.relu(x - 1)
```

## Input contract

The operation accepts a PyTorch tensor with:

- CPU device;
- `torch.float32` data type;
- any tensor shape.

Other devices and data types are not supported.

## Build the wheel

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip wheel
python -m pip install torch --index-url https://download.pytorch.org/whl/cpu
python -m pip wheel . --no-deps --no-build-isolation -w dist
```

## Install the wheel

```bash
python -m pip install dist/*.whl
```

## Run tests

```bash
python -m pip install -r requirements-dev.txt
python -m pytest -q
```

## Make targets

```bash
make wheel
make install
make test
make lint
make smoke
make profile
make clean
```

## Smoke test

```bash
./tools/smoke.sh
```

The smoke test builds a Linux wheel, installs it into a fresh virtual
environment, and imports the installed package from `/tmp`.

## Docker

```bash
docker build -t fse-ops:0.1 .
docker run --rm fse-ops:0.1
```

## Team branches

- `feature/cpp-packaging`: C++ operation and packaging;
- `feature/tests-ci`: tests and continuous integration;
- `feature/docker-smoke-docs`: Docker, smoke test, Makefile, and documentation.
