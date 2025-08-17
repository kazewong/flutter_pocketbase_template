# Use Debian Bookworm as the base image
FROM debian:bookworm

ENV FLUTTER_VERSION=3.35.1-stable

# Install dependencies for linux 
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl git unzip xz-utils zip libglu1-mesa \
    clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies for Web SDK
# Install chrome for web support

RUN apt-get update && apt-get install -y \
    wget gnupg2 \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*
    
# Install dependencies for Android SDK

RUN apt-get update && apt-get install -y \
    libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter SDK

WORKDIR /app

RUN mkdir -p /app/flutter && \
    curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz | tar -xJ -C /app/

# Use non-root user
RUN useradd -ms /bin/bash flutteruser
USER flutteruser

# Add Flutter to PATH
ENV PATH="/app/flutter/bin:${PATH}"

RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip && \
    unzip pocketbase_${PB_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm pocketbase_${PB_VERSION}_linux_amd64.zip

# Enable Flutter web support
# RUN flutter config --enable-web

