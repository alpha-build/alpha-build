#!/usr/bin/env bash

# !!!! NOTE: Run Git bash as administrator to run this script!!!!!

# https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058
echo "Installing make"

# Imports
. lib_sh_utils/src/commands.sh

MAKE_DOWNLOAD_URL="https://sourceforge.net/projects/ezwinports/files/make-4.3-without-guile-w32-bin.zip/download"
curl -kL $MAKE_DOWNLOAD_URL --output install_make.zip
unzip install_make.zip -d install_make
rm install_make.zip

ensure_mingw64_dir() {
	if [ ! -d "/mingw64/$1" ]; then
		CREATE_DIR="mkdir /mingw64/$1"
		echo "$CREATE_DIR"
		eval "$CREATE_DIR"
	fi
}

ensure_mingw64_dir bin
cp install_make/bin/* /mingw64/bin/

ensure_mingw64_dir include
cp install_make/include/* /mingw64/include/

ensure_mingw64_dir lib
cp install_make/lib/* /mingw64/lib/

ensure_mingw64_dir share
ensure_mingw64_dir share/doc
cp -r install_make/share/doc/* /mingw64/share/doc/
ensure_mingw64_dir share/info
cp install_make/share/info/* /mingw64/share/info/
ensure_mingw64_dir share/man
cp -r install_make/share/man/* /mingw64/share/man/

echo ""
echo "Installed make"
assert_command_exists make
rm -rf install_make
