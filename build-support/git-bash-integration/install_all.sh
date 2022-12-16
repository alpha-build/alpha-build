#!/usr/bin/env bash

GIT_BASH_UTILS_LIB_ROOT=$(realpath "${GIT_BASH_UTILS_LIB_ROOT:-$(dirname "${BASH_SOURCE[0]}")}")

"$GIT_BASH_UTILS_LIB_ROOT"/install_make.sh
"$GIT_BASH_UTILS_LIB_ROOT"/install_zstd.sh
"$GIT_BASH_UTILS_LIB_ROOT"/install_libzstd.sh
"$GIT_BASH_UTILS_LIB_ROOT"/install_libxxhash.sh
"$GIT_BASH_UTILS_LIB_ROOT"/install_rsync.sh
