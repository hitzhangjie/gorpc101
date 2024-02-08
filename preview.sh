#!/bin/bash -e

docker run --name gorpc --rm \
    -p 4000:4000 -p 35729:35729 \
    -v $(pwd -P):/root/gitbook hitzhangjie/gitbook-cli:latest \
    gitbook serve
