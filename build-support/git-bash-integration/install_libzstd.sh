#!/usr/bin/env bash

# !!!! NOTE: Run Git bash as administrator to run this script!!!!!

# https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058
echo "Installing libzstd"

DOWNLOAD_URL="http://repo.msys2.org/msys/x86_64/libzstd-1.5.0-1-x86_64.pkg.tar.zst"
curl -kL $DOWNLOAD_URL --output install_libzstd.pkg.tar.zst
mkdir -p install_libzstd
tar -I zstd -xvf install_libzstd.pkg.tar.zst --directory install_libzstd
rm -f install_libzstd.pkg.tar.zst

cp install_libzstd/usr/bin/msys-zstd-1.dll /usr/bin/

echo ""
echo "Installed libzstd"
rm -rf install_libzstd
