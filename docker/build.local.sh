#!/bin/bash

cd "$(dirname "$0")"

sudo docker build --force-rm -t maxrd2/arch-build -f Dockerfile.local .

