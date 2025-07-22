#!/bin/bash

OUT_DIR="dist/desktop"
mkdir -p $OUT_DIR
odin build src/main_desktop -out:$OUT_DIR/game_desktop.bin
cp -R ./assets/ ./$OUT_DIR/assets/
echo "Desktop build created in ${OUT_DIR}"
