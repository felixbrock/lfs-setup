#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 5 (gcc-pass1)
set -euo pipefail
cd "$LFS/sources"
rm -rf gcc-15.2.0
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd       build

# Deviation from book: host GCC 16 defaults to C++20, where u8"" literals
# are char8_t and break the bundled libcody. Pin the host compiler to the
# C++17 dialect GCC 15.2's sources expect. Pass-1-only; later GCC builds
# use our own GCC 15.2 (default gnu++17).
../configure                  \
    CXX="g++ -std=gnu++17"    \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.43 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make

make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h

cd "$LFS/sources"
rm -rf gcc-15.2.0
echo "### 20-gcc-pass1: complete"
