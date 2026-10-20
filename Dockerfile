FROM ubuntu:24.04 AS build

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        python3 \
        python3-dev \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN python3 -m pip install --break-system-packages --no-cache-dir \
    torch --index-url https://download.pytorch.org/whl/cpu

COPY . .

RUN python3 -m pip wheel . --no-deps -w /wheels


FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages --no-cache-dir \
    torch --index-url https://download.pytorch.org/whl/cpu \
    && python3 -m pip install --break-system-packages --no-cache-dir pytest

COPY --from=build /wheels /wheels

RUN python3 -m pip install --break-system-packages --no-cache-dir \
    /wheels/*.whl

COPY tests /opt/tests

WORKDIR /tmp

CMD ["python3", "-m", "pytest", "-q", "/opt/tests"]
