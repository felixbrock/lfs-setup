#!/bin/bash
# Generated from BLFS 13.0-systemd (x/mesa.html) — runs inside chroot as root
# 2026-07-19: 25.3.5 -> 25.3.6 (lfs-config#1: CVE-2026-40393 WebGPU OOB write; same-branch bump)
# Included book blocks: [1, 2, 4, 5] of 6; '&&' chains split into plain statements
# xdemos patch applied (adds glxinfo/glxgears). skipped: 0 (lspci info), 3 (tests). DEVIATIONS per plan: platforms=x11 (no wayland libs in tier 1/2), gallium-drivers=llvmpipe,virgl,iris (QEMU + Iris Xe on metal, added 2026-07-16), vulkan-drivers empty
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf mesa-25.3.6
tar -xf mesa-25.3.6.tar.xz
cd mesa-25.3.6

patch -Np1 -i ../mesa-add_xdemos-4.patch

mkdir build
cd    build

meson setup ..                 \
      --prefix=$XORG_PREFIX    \
      --buildtype=release      \
      -D platforms=x11         \
      -D gallium-drivers=llvmpipe,virgl,iris \
      -D vulkan-drivers=""     \
      -D valgrind=disabled     \
      -D video-codecs=all      \
      -D libunwind=disabled

# -j10: no swap on this system — see the 302-llvm OOM note
ninja -j10

ninja install

cp -rv ../docs -T /usr/share/doc/mesa-25.3.6

cd /sources/blfs
rm -rf mesa-25.3.6
echo "### 303-mesa: complete"
