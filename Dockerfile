FROM python:3.12-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN apt-get update && apt-get install -y socat git gcc g++ python3-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN uv pip install --system -r requirements.txt && \
    uv pip install --system "grpcio>=1.60.0" "grpcio-status>=1.60.0" "protobuf>=4.25.0"
COPY . .

ENTRYPOINT ["/bin/bash", "-c"]