#!/usr/bin/env bash
# Imports
. lib_sh_utils/src/commands.sh

conda install -c conda-forge zstd -y
#curl -fsSL https://raw.githubusercontent.com/horta/zstd.install/main/install
#choco install zstandard -y
assert_command_exists zstd
