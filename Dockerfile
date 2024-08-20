FROM python:3.12-slim as builder

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

# Conditional installation script for PyTorch and torchvision
COPY install_pytorch.sh /install_pytorch.sh
RUN chmod +x /install_pytorch.sh && /install_pytorch.sh

# Install Python dependencies
RUN pip install --no-cache-dir nltk timm pikepdf 'transformers[torch]'

# Copy the script that pre-downloads models and NLTK data
COPY pre_download_models.py /pre_download_models.py

# Run the script to pre-download models and NLTK data
RUN python /pre_download_models.py