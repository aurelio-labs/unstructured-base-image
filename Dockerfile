FROM python:3.11-slim as builder

# Set build environment variable
ENV DOCKER_BUILDKIT=1

# Install build dependencies
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    make \
    git \
    libtool \
    autoconf \
    automake \
    clang \
    build-essential \
    zlib1g-dev \
    libtiff5-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    libopencv-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Leptonica
RUN wget https://github.com/DanBloomberg/leptonica/releases/download/1.84.1/leptonica-1.84.1.tar.gz \
    && tar -xzvf leptonica-1.84.1.tar.gz \
    && cd leptonica-1.84.1 \
    && ./configure && make -j$(nproc) && make install

# Install Tesseract
RUN git clone --depth 1 --branch 5.3.4 https://github.com/tesseract-ocr/tesseract.git tesseract-ocr \
    && cd tesseract-ocr \
    && ./autogen.sh && ./configure --prefix=/usr/local --disable-shared --enable-static --with-extra-libraries=/usr/local/lib/ --with-extra-includes=/usr/local/lib/ \
    && make -j$(nproc) && make install


FROM python:3.11-slim

LABEL maintainer="aurelio" \
    vendor="aurelio"

# Set environment variables
ENV GPU_ENABLED=false \
    PANDOC_VERSION=3.1.9

# Copy Tesseract and Leptonica from the builder stage
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/local/share /usr/local/share

# Install runtime dependencies and necessary tools
RUN apt-get update && apt-get install -y \
    poppler-utils \
    xz-utils \
    wget \
    tar \
    make \
    git \
    g++ \
    python3-dev \
    && pip install nltk \
    && python -m nltk.downloader punkt -d /root/nltk_data \
    && rm -rf /var/lib/apt/lists/*

# Install Pandoc (adjust if necessary for Alpine)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then PANDOC_ARCH="amd64"; elif [ "$ARCH" = "arm64" ]; then PANDOC_ARCH="arm64"; fi && \
    pandoc_filename=pandoc-"$PANDOC_VERSION"-linux-"$PANDOC_ARCH".tar.gz && \
    pandoc_url=https://github.com/jgm/pandoc/releases/download/"$PANDOC_VERSION"/"$pandoc_filename" && \
    wget "$pandoc_url" && \
    tar xvzf "$pandoc_filename" --strip-components 1 -C '/usr/local' && \
    rm -rf "$pandoc_filename"

# Install Tesseract language data
RUN git clone https://github.com/tesseract-ocr/tessdata.git \
    && cp tessdata/*.traineddata /usr/local/share/tessdata \
    && rm -rf tessdata
