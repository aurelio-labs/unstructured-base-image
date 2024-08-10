#!/bin/bash

ARCH=$(uname -m)
OS=$(uname)

if [[ "$OS" == "Darwin" ]]; then
    pip install torch==2.2.1 torchvision==0.17.1
elif [[ "$ARCH" == "aarch64" ]]; then
    pip install torch==2.2.1 torchvision==0.17.1
else
    pip install --extra-index-url https://download.pytorch.org/whl/cpu torch==2.2.1 torchvision==0.17.1
fi