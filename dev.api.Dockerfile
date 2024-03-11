FROM python:3.11.8-slim-bookworm as base

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    gnupg2 \
    curl \
    libpq-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

FROM base as requirements

RUN python -m pip install -U pip setuptools
RUN pip install poetry==1.7.1

COPY pyproject.toml poetry.lock ./ 
RUN poetry export -f requirements.txt --without-hashes -o /requirements.txt 

FROM base as app

COPY --from=requirements /requirements.txt . 

RUN python -m pip install --no-cache-dir -r requirements.txt

# COPY olaw/ app/

RUN apt-get purge -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*
