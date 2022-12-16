#!/usr/bin/env bash

GIT_BASH_UTILS_LIB_ROOT=$(realpath "${GIT_BASH_UTILS_LIB_ROOT:-$(dirname "${BASH_SOURCE[0]}")}")

# Imports
# shellcheck source=build-support/git-bash-integration/utils.sh
source "$GIT_BASH_UTILS_LIB_ROOT/utils.sh"

conda install -c conda-forge zstd -y
#curl -fsSL https://raw.githubusercontent.com/horta/zstd.install/main/install
#choco install zstandard -y
assert_command_exists zstd
