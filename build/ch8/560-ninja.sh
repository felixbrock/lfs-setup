#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (ninja) — runs inside chroot
# Included book blocks: [1, 2] of 3; tolerant: []
set -euo pipefail
cd /sources
rm -rf ninja-1.13.2
tar -xf ninja-1.13.2.tar.gz
cd ninja-1.13.2

python3 configure.py --bootstrap --verbose

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

cd /sources
rm -rf ninja-1.13.2
echo "### 560-ninja: complete"
