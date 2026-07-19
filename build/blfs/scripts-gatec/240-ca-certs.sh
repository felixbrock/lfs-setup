#!/bin/bash
# p11-kit + make-ca (BLFS postlfs) — system CA trust store. Without this,
# every OpenSSL/Go/system-trust consumer (docker, curl-in-VM, git https)
# fails TLS verification. NSS apps (brave) bundle their own roots.
set -euo pipefail
cd /sources/blfs

# --- libtasn1 (p11-kit Required dep; without it the trust module is
# silently skipped and make-ca has no /usr/bin/trust) ---
rm -rf libtasn1-4.21.0
tar -xf libtasn1-4.21.0.tar.gz
cd libtasn1-4.21.0
./configure --prefix=/usr --disable-static
make
make install
cd /sources/blfs
rm -rf libtasn1-4.21.0

# --- p11-kit ---
rm -rf p11-kit-0.26.4
tar -xf p11-kit-0.26.4.tar.xz
cd p11-kit-0.26.4

sed '20,$ d' -i trust/trust-extract-compat
cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

mkdir p11-build
cd    p11-build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D trust_paths=/etc/pki/anchors
ninja

ninja install
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates
ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

cd /sources/blfs
rm -rf p11-kit-0.26.4

# --- make-ca ---
rm -rf make-ca-1.16.1
tar -xf make-ca-1.16.1.tar.gz
cd make-ca-1.16.1

sed '/mktemp/s/-t //' -i make-ca

make install
install -vdm755 /etc/ssl/local

# generate stores from the local certdata.txt (downloaded on host;
# make-ca -g would fetch it itself but chroot has no DNS)
/usr/sbin/make-ca -C /sources/blfs/certdata.txt

systemctl enable update-pki.timer

cd /sources/blfs
rm -rf make-ca-1.16.1
echo "### 240-ca-certs: complete"
