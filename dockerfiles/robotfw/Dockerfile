FROM --platform=linux/amd64 python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends gnupg2 \
    && apt-get install -y --no-install-recommends ca-certificates curl socat \
    && apt-get install -y --no-install-recommends xvfb x11vnc fluxbox xterm \
    && apt-get install -y --no-install-recommends sudo \
    && apt-get install -y --no-install-recommends supervisor \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt update \
    && apt install google-chrome-stable -y \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - \
    && apt install -y nodejs

WORKDIR /app
COPY . .

RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev  --no-interaction --no-ansi
RUN rfbrowser init
