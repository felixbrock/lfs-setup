#!/bin/bash
# LFS chapter 10 kernel build — runs inside the chroot (or natively on
# the live system; see the gated pipeline for the additive-install
# variant with boot counting).
#
# BLUEPRINT NOTE: this is the GENERIC skeleton. Real hardware
# enablement lives in a per-instance overlay script (private ops repo)
# that extends the config blocks below — cameras, touchpads, GPU,
# audio DSPs, Type-C, and their war stories belong there, not here.
# Two patterns from operating this blueprint that the skeleton
# enforces, both learned the hard way (see case-studies/):
#
#   1. THE CONFIG-VERIFY GATE. `make olddefconfig` silently DROPS any
#      option whose dependencies are unmet. Every option you add below
#      must also appear in the verify loop at the bottom — a dropped
#      option then fails the build instead of shipping a kernel that
#      silently lacks it.
#   2. FIRMWARE vs BUILT-IN. A =y driver probes while the initramfs is
#      still the root filesystem; a firmware load that fails there is
#      NOT retried after switch_root. Any driver that needs firmware
#      at probe time must either be =m (loads late, firmware from the
#      real /usr/lib/firmware) or have its firmware staged into the
#      initramfs. When in doubt: =m.
set -euo pipefail
cd /sources
rm -rf linux-6.18.38
tar -xf linux-6.18.38.tar.xz
cd linux-6.18.38

make mrproper
make defconfig

# systemd/udev requirements (most are already on in defconfig; enforce)
./scripts/config \
  -e DEVTMPFS -e DEVTMPFS_MOUNT -e CGROUPS -e INOTIFY_USER -e SIGNALFD \
  -e TIMERFD -e EPOLL -e FHANDLE -e NET -e UNIX -e SYSFS -e PROC_FS \
  -e TMPFS -e TMPFS_POSIX_ACL -e TMPFS_XATTR -e SECCOMP -e SECCOMP_FILTER \
  -e DMIID -e AUTOFS_FS -e BINFMT_MISC -e PSI -e USER_NS \
  -d UEVENT_HELPER -d FW_LOADER_USER_HELPER

# filesystems + boot chain: adjust to your root filesystem and media.
# Anything the initramfs must mount without loading modules is =y.
./scripts/config \
  -e EXT4_FS -e EXT4_FS_POSIX_ACL \
  -e BTRFS_FS -e BTRFS_FS_POSIX_ACL \
  -e BLK_DEV_NVME \
  -e MD -e BLK_DEV_DM -e DM_CRYPT \
  -e CRYPTO_AES_NI_INTEL -e CRYPTO_XTS -e CRYPTO_SHA256 -e CRYPTO_SHA512 \
  -e EFI -e EFI_STUB -e EFIVAR_FS \
  -e VFAT_FS -e NLS_CODEPAGE_437 -e NLS_ISO8859_1

# console before the GPU driver loads: with a modular display driver
# (pattern 2 above), simpledrm carries the framebuffer console from
# EFI hand-off until the real driver takes over. Without
# SYSFB_SIMPLEFB, DRM_SIMPLEDRM is silently inert — an invisible
# LUKS prompt on first boot is how you find out.
./scripts/config \
  -e DRM -e DRM_FBDEV_EMULATION -e FRAMEBUFFER_CONSOLE \
  -e DRM_SIMPLEDRM -e SYSFB_SIMPLEFB

# desktop baseline (BLFS): evdev for libinput, uinput for key remappers
./scripts/config \
  -e INPUT_EVDEV -e INPUT_UINPUT -e INPUT_MISC \
  -e SOUND -e SND -e SND_HDA_INTEL -e SND_HDA_CODEC_GENERIC

# --- instance hardware overlay goes here -----------------------------
# (private ops repo: GPU =m, audio DSP =m, touchpad bus drivers,
#  Type-C/UCSI, Wi-Fi/BT, thermals, container networking, ...)
# ---------------------------------------------------------------------

make olddefconfig

# THE CONFIG-VERIFY GATE (pattern 1): every option added above must
# survive olddefconfig; extend this list together with the blocks.
for opt in CONFIG_BTRFS_FS=y \
           CONFIG_DM_CRYPT=y \
           CONFIG_DRM_SIMPLEDRM=y \
           CONFIG_SYSFB_SIMPLEFB=y \
           CONFIG_FRAMEBUFFER_CONSOLE=y \
           CONFIG_INPUT_EVDEV=y \
           CONFIG_INPUT_UINPUT=y; do
  grep -qx "$opt" .config || { echo "config verification FAILED: $opt"; exit 1; }
done

make -j"$(nproc)"
make modules_install

cp -v arch/x86/boot/bzImage /boot/vmlinuz-6.18.38-lfs-13.0-systemd
cp -v System.map /boot/System.map-6.18.38
cp -v .config /boot/config-6.18.38

cd /sources
rm -rf linux-6.18.38
echo "### 020-kernel: complete"
