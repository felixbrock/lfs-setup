#!/bin/bash
# nasm (BLFS general/nasm.html) — assembler; enables ffmpeg's x86 asm paths.
set -euo pipefail
cd /sources/blfs
rm -rf nasm-3.01
tar -xf nasm-3.01.tar.xz
cd nasm-3.01

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf nasm-3.01
echo "### 245-nasm: complete"
