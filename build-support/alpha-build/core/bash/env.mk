# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

.PHONY: env-sh-default-replicate
env-sh-default-upgrade:
	cat $(NPM_DEV_SH_DEPS) | tr -d "\r" | $(gnu_xargs) npm --prefix $(DEFAULT_SH_ENV) install --save-dev --registry=https://registry.npmjs.org

.PHONY: env-sh-default-upgrade
env-sh-default-replicate:
	npm --prefix $(DEFAULT_SH_ENV) ci  --registry=https://registry.npmjs.org || echo "Check manually if it passes, since it causes make to fail unexpectedly !!!"
