FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && \
    apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    curl \
    git \
    python3-dev \
    docker.io

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

RUN mkdir /venv/
WORKDIR /venv
COPY ./pyproject.toml /venv/pyproject.toml
COPY ./uv.lock /venv/uv.lock
RUN uv venv
RUN uv sync

RUN mkdir /app
COPY . /app/
WORKDIR /app
RUN chmod +x /app/entrypoint.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/*