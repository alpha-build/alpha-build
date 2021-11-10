BATS_BIN=3rdparty/sh-env/node_modules/bats/bin/bats

# Environment set-up
# - shellcheck comes from pip (built with the python env)
# - shfmt comes from conda (built with the python env)
# - bats comes from npm (built separately)
DEFAULT_SH_ENV=3rdparty/sh-env
NPM_DEV_SH_DEPS=$(DEFAULT_SH_ENV)/npm-dev-deps.txt

# Flags
SHELLCHECK_FLAGS=-x --format=gcc -e SC1017
