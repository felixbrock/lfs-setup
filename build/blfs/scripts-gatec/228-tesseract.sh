#!/bin/bash
# not in BLFS — upstream GitHub archive, autotools (autogen.sh; needs leptonica 227); eng+deu traineddata installed to /usr/share/tessdata — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf tesseract-5.5.1
tar -xf tesseract-5.5.1.tar.gz
cd tesseract-5.5.1

./autogen.sh
./configure --prefix=/usr
make

make install

# language data (downloaded separately into /sources/blfs, tessdata_fast)
install -v -Dm644 /sources/blfs/eng.traineddata -t /usr/share/tessdata
install -v -Dm644 /sources/blfs/deu.traineddata -t /usr/share/tessdata

cd /sources/blfs
rm -rf tesseract-5.5.1
echo "### 228-tesseract: complete"
