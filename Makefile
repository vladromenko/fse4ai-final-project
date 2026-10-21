PYTHON ?= python3
IMAGE ?= fse-ops:0.1

.PHONY: wheel install test lint smoke profile docker-build docker-test clean

wheel:
	$(PYTHON) -m pip wheel . --no-deps -w dist

install:
	$(PYTHON) -m pip install dist/*.whl

test:
	$(PYTHON) -m pytest -q

lint:
	$(PYTHON) -m ruff check .

smoke:
	./tools/smoke.sh

profile:
	$(PYTHON) -m cProfile -s cumulative tools/profile_op.py

docker-build:
	docker build -t $(IMAGE) .

docker-test:
	docker run --rm $(IMAGE)

clean:
	rm -rf build dist .pytest_cache .ruff_cache
	rm -rf ./*.egg-info src/*.egg-info
	find src tests tools -type d -name __pycache__ -prune -exec rm -rf {} +
	find src tests tools -type f -name '*.py[co]' -delete