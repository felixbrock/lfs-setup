#!/bin/bash
# Generated from BLFS 13.0-systemd (x/x7app.html) — runs inside chroot as root
# Group build: manifest + build loop taken verbatim from the page; the
# page's wget download block is replaced by copying the (already
# downloaded) tarballs from /sources/blfs; as_root dropped (we are root).
# Manifest lines removed per plan: xdriinfo
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xorg-apps-work
mkdir xorg-apps-work
cd xorg-apps-work

cat > app-7.md5 << "EOF"
30f898d71a7d8e817302970f1976198c  iceauth-1.0.10.tar.xz
7dcf5f702781bdd4aaff02e963a56270  mkfontscale-1.2.3.tar.xz
b9efe1d21615c474b22439d41981beef  sessreg-1.1.4.tar.xz
1d61c9f4a3d1486eff575bf233e5776c  setxkbmap-1.3.4.tar.xz
6484cd8ee30354aaaf8f490988f5f6ef  smproxy-1.0.8.tar.xz
9cfdec89ad7bd86bcdfda150ae995955  xauth-1.1.5.tar.xz
37063ccf902fe3d55a90f387ed62fe1f  xcmsdb-1.0.7.tar.xz
f97e81b2c063f6ae9b18d4b4be7543f6  xcursorgen-1.0.9.tar.xz
700556957773d378fa16a65a4406be0a  xdpyinfo-1.4.0.tar.xz
f29d1544f8dd126a1b85e2f7f728672d  xev-1.2.6.tar.xz
687e42aa5afaec37f14da3072651c635  xgamma-1.0.8.tar.xz
45c7e956941194e5f06a9c7307f5f971  xhost-1.0.10.tar.xz
8e4d14823b7cbefe1581c398c6ab0035  xinput-1.6.4.tar.xz
b8128ff6816897bd385ca437cd2886ee  xkbcomp-1.5.0.tar.xz
543c0535367ca30e0b0dbcfa90fefdf9  xkbevd-1.1.6.tar.xz
07483ddfe1d83c197df792650583ff20  xkbutils-1.0.6.tar.xz
294db9393a9d8e6613e1e3dd4fe0273f  xkill-1.0.7.tar.xz
da5b7a39702841281e1d86b7349a03ba  xlsatoms-1.1.4.tar.xz
ab4b3c47e848ba8c3e47c021230ab23a  xlsclients-1.1.5.tar.xz
ba2dd3db3361e374fefe2b1c797c46eb  xmessage-1.0.7.tar.xz
0d66e07595ea083871048c4b805d8b13  xmodmap-1.0.11.tar.xz
ab6c9d17eb1940afcfb80a72319270ae  xpr-1.2.0.tar.xz
5ef4784b406d11bed0fdf07cc6fba16c  xprop-1.2.8.tar.xz
dc7680201afe6de0966c76d304159bda  xrandr-1.5.3.tar.xz
c8629d5a0bc878d10ac49e1b290bf453  xrdb-1.2.2.tar.xz
55003733ef417db8fafce588ca74d584  xrefresh-1.1.0.tar.xz
18ff5cdff59015722431d568a5c0bad2  xset-1.2.5.tar.xz
fa9a24fe5b1725c52a4566a62dd0a50d  xsetroot-1.1.3.tar.xz
d698862e9cad153c5fefca6eee964685  xvinfo-1.1.5.tar.xz
b0081fb92ae56510958024242ed1bc23  xwd-1.0.9.tar.xz
c91201bc1eb5e7b38933be8d0f7f16a8  xwininfo-1.1.6.tar.xz
3e741db39b58be4fef705e251947993d  xwud-1.0.7.tar.xz
EOF

mkdir build
cd build
for t in $(grep -v '^#' ../app-7.md5 | awk '{print $2}'); do
  cp -v /sources/blfs/$t .
done
md5sum -c ../app-7.md5

for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}')
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

rm -f $XORG_PREFIX/bin/xkeystone

cd /sources/blfs
rm -rf xorg-apps-work
echo "### 070-xorg-apps: complete"
