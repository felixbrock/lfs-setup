#!/bin/bash
# BLFS GRUB 2.14 for EFI — adds the x86_64-efi platform next to the ch8
# BIOS build (same version; make install just adds the platform dir and
# refreshed tools). No unifont/grub-mkfont: text menu is enough.
# Runs inside chroot.
set -euo pipefail
cd /sources
rm -rf grub-2.14
tar -xf grub-2.14.tar.xz
cd grub-2.14

unset {C,CPP,CXX,LD}FLAGS

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-efiemu \
            --with-platform=efi \
            --target=x86_64 \
            --disable-werror
make
make install

if [ -e /etc/bash_completion.d/grub ]; then
  mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
fi

ls /usr/lib/grub/x86_64-efi/core.img 2>/dev/null || ls /usr/lib/grub/x86_64-efi | head -3
grub-install --version

cd /sources
rm -rf grub-2.14
echo "### 050-grub-efi: complete"
