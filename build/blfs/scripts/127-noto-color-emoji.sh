#!/bin/bash
# upstream, not in BLFS — bare ttf file at /sources/blfs/NotoColorEmoji.ttf — runs inside chroot as root
set -euo pipefail

install -v -Dm644 /sources/blfs/NotoColorEmoji.ttf \
    /usr/share/fonts/noto/NotoColorEmoji.ttf
fc-cache -v /usr/share/fonts/noto
echo "### 127-noto-color-emoji: complete"
