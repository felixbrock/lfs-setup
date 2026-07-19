#!/bin/bash
# NOT from the book (book uses interactive 'passwd root'): temporary root
# password for the QEMU phase. MUST be changed before hardware migration
# (tracked in config repo VERIFICATION.md, Gate D).
set -euo pipefail
echo 'root:lfs' | chpasswd
echo "### 895-root-password: complete"
