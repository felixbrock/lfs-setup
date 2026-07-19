#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (gcc) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21] of 22; tolerant: [7, 8]
set -euo pipefail
cd /sources
rm -rf gcc-15.2.0
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

sed -i 's/char [*]q/const &/' libgomp/affinity-fmt.c

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -v build
cd       build

../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib

make

ulimit -s -H unlimited

sed -e '/cpython/d' -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp

(
chown -R tester .
su tester -c "PATH=$PATH make -k check"
) || true   # book: nonzero exit / known failures tolerated, log reviewed

(
../contrib/test_summary
) || true   # book: nonzero exit / known failures tolerated, log reviewed

make install

chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/15.2.0/include{,-fixed}

ln -svr /usr/bin/cpp /usr/lib

ln -sv gcc.1 /usr/share/man/man1/cc.1

ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/15.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/

echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log

grep -B4 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib.*/libc.so.6 " dummy.log

grep found dummy.log

rm -v a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

cd /sources
rm -rf gcc-15.2.0
echo "### 280-gcc: complete"
