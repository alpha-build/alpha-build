# Environment
# - markdownlint comes from npm
DEFAULT_MD_ENV=3rdparty/md-env
DEFAULT_NPM_DEV_MD_DEPS=$(DEFAULT_MD_ENV)/npm-dev-deps.txt

# Binaries
MARKDOWNLINT_BIN="./$(DEFAULT_MD_ENV)/node_modules/.bin/markdownlint"

# Flags
MARKDOWNLINT_FLAGS=--config build-support/markdown/tools-config/markdownlint.yml
