#!/bin/bash
# ffmpeg (BLFS multimedia/ffmpeg.html) — DEVIATION from book: none of the
# external codec libs (x264/x265/aom/svt-av1/fdk-aac/lame/opus/vorbis/ass)
# are in tier 1, so this is a bare GPL build. Internal decoders cover
# playback/probing; encoding via external codecs is deferred until a real
# use case (register: tier-2-media). Chromium patch skipped (browser is an
# upstream binary, doesn't use system ffmpeg).
set -euo pipefail
cd /sources/blfs
rm -rf ffmpeg-8.1.2
tar -xf ffmpeg-8.1.2.tar.xz
cd ffmpeg-8.1.2

./configure --prefix=/usr     \
            --enable-gpl      \
            --enable-version3 \
            --disable-static  \
            --enable-shared   \
            --disable-debug
make

make install

cd /sources/blfs
rm -rf ffmpeg-8.1.2
echo "### 246-ffmpeg: complete"
