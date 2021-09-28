#!/usr/bin/env bash

# !!!! NOTE: Run Git bash as administrator to run this script!!!!!

CHECKOUT_ROOT=$(realpath "${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../..}")

# Imports
# shellcheck source=build-support/git-bash-integration/utils.sh
source "$CHECKOUT_ROOT/build-support/git-bash-integration/utils.sh"

# https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058
echo "Installing rsync"

DOWNLOAD_URL="http://repo.msys2.org/msys/x86_64/rsync-3.2.3-1-x86_64.pkg.tar.zst"
curl -kL $DOWNLOAD_URL --output install_rsync.pkg.tar.zst
mkdir -p install_rsync
tar -I zstd -xvf install_rsync.pkg.tar.zst --directory install_rsync
rm -f install_rsync.pkg.tar.zst

cp install_rsync/usr/bin/rsync.exe /usr/bin/
cp -r install_rsync/usr/lib/rsync /usr/lib/

echo ""
assert_command_exists rsync
rm -rf install_rsync
