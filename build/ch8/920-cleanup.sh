#!/bin/bash
# LFS 13.0-systemd 8.86 cleanup
set -euo pipefail

(
rm -rf /tmp/{*,.*}
) || true   # rm -rf /tmp/.* always complains about . and ..

find /usr/lib /usr/libexec -name \*.la -delete

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

userdel -r tester

echo "### 920-cleanup: complete"
