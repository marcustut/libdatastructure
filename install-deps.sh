#!/bin/bash

set -e

INCLUDE_DIR=/usr/local/include
LIB_DIR=/usr/local/lib

echo "Installing criterion..."

[[ ! -d $INCLUDE_DIR/criterion ]] && \
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        git clone https://github.com/Snaipe/Criterion.git && \
        cd Criterion && \
        meson build && \
        sudo meson install -C build && \
        cd .. && \
        sudo rm -r Criterion
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install criterion
    fi

echo "Installed criterion!"