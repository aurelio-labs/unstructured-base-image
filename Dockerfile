FROM python:3.11-slim as builder

ENV DOCKER_BUILDKIT=1

LABEL org.opencontainers.image.source=https://github.com/aurelio-labs/unstructured-base-image

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    poppler-utils \
    tesseract-ocr \
    ffmpeg \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Tesseract language data (english and osd)
RUN mkdir -p /usr/local/share/tessdata && \
    cd /usr/local/share/tessdata && \
    curl -O https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata && \
    curl -O https://github.com/tesseract-ocr/tessdata/raw/main/osd.traineddata
