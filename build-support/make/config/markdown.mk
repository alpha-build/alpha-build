# Environment
# - markdownlint comes from npm
DEFAULT_MD_ENV=3rdparty/md-env-ws
DEFAULT_NPM_DEV_MD_DEPS=$(DEFAULT_MD_ENV)/npm-dev-deps.txt

# Binaries
MARKDOWNLINT_BIN="./3rdparty/md-env-ws/node_modules/.bin/markdownlint"

# Flags
MARKDOWNLINT_FLAGS=--config build-support/markdown/tools-config/markdownlint.yml
