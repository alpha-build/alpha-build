#!/usr/bin/env bash

# !!!! NOTE: Run Git bash as administrator to run this script!!!!!

# https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058
echo "Installing libxxhash"

DOWNLOAD_URL="http://repo.msys2.org/msys/x86_64/libxxhash-0.8.0-1-x86_64.pkg.tar.zst"
curl -kL $DOWNLOAD_URL --output install_libxxhash.pkg.tar.zst
mkdir -p install_libxxhash
tar -I zstd -xvf install_libxxhash.pkg.tar.zst --directory install_libxxhash
rm -f install_libxxhash.pkg.tar.zst

cp install_libxxhash/usr/bin/msys-xxhash-0.8.0.dll /usr/bin/

echo ""
echo "Installed libxxhash"
rm -rf install_libxxhash
