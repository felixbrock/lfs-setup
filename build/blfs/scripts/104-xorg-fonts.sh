#!/bin/bash
# Generated from BLFS 13.0-systemd (x/x7font.html) — runs inside chroot as root
# Group build: manifest + build loop taken verbatim from the page; the
# page's wget download block is replaced by copying the (already
# downloaded) tarballs from /sources/blfs; as_root dropped (we are root).
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xorg-fonts-work
mkdir xorg-fonts-work
cd xorg-fonts-work

cat > font-7.md5 << "EOF"
a6541d12ceba004c0c1e3df900324642  font-util-1.4.1.tar.xz
a56b1a7f2c14173f71f010225fa131f1  encodings-1.1.0.tar.xz
dd1a744b97eb6d388d4e78b17011193e  font-alias-1.0.6.tar.xz
546d17feab30d4e3abcf332b454f58ed  font-adobe-utopia-type1-1.0.5.tar.xz
063bfa1456c8a68208bf96a33f472bb1  font-bh-ttf-1.0.4.tar.xz
51a17c981275439b85e15430a3d711ee  font-bh-type1-1.0.4.tar.xz
00f64a84b6c9886040241e081347a853  font-ibm-type1-1.0.4.tar.xz
fe972eaf13176fa9aa7e74a12ecc801a  font-misc-ethiopic-1.0.5.tar.xz
3b47fed2c032af3a32aad9acc1d25150  font-xfree86-type1-1.0.5.tar.xz
EOF

mkdir build
cd build
for t in $(grep -v '^#' ../font-7.md5 | awk '{print $2}'); do
  cp -v /sources/blfs/$t .
done
md5sum -c ../font-7.md5

for package in $(grep -v '^#' ../font-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
    ./configure $XORG_CONFIG
    make
    make install
  popd
  rm -rf $packagedir
done

install -v -d -m755 /usr/share/fonts
ln -svfn $XORG_PREFIX/share/fonts/X11/OTF /usr/share/fonts/X11-OTF
ln -svfn $XORG_PREFIX/share/fonts/X11/TTF /usr/share/fonts/X11-TTF

cd /sources/blfs
rm -rf xorg-fonts-work
echo "### 104-xorg-fonts: complete"
