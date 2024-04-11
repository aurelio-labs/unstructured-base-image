FROM python:3.11-slim as builder

ENV DOCKER_BUILDKIT=1

LABEL org.opencontainers.image.source=https://github.com/aurelio-labs/unstructured-base-image

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    poppler-utils \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*


FROM python:3.11-slim

LABEL maintainer="aurelio" \
    vendor="aurelio"

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/local/share /usr/local/share

# Install runtime dependencies and necessary tools
# CPU
RUN pip install torch==2.2.1 torchvision==0.17.1 --index-url https://download.pytorch.org/whl/cpu && \
    pip install "unstructured[pdf]==0.13.2"
