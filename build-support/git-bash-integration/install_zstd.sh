#!/usr/bin/env bash

CHECKOUT_ROOT=$(realpath "${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../..}")

# Imports
# shellcheck source=build-support/git-bash-integration/utils.sh
source "$CHECKOUT_ROOT/build-support/git-bash-integration/utils.sh"

conda install -c conda-forge zstd -y
#curl -fsSL https://raw.githubusercontent.com/horta/zstd.install/main/install
#choco install zstandard -y
assert_command_exists zstd
