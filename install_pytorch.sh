#!/bin/bash

ARCH=$(uname -m)
OS=$(uname)

if [[ "$OS" == "Darwin" ]]; then
    pip install torch==2.2.0 torchvision==0.17.0
elif [[ "$ARCH" == "aarch64" ]]; then
    pip install torch==2.2.0 torchvision==0.17.0
else
    pip install --extra-index-url https://download.pytorch.org/whl/cpu torch==2.2.0 torchvision==0.17.0
fi