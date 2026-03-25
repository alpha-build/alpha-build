# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

.PHONY: pre-commit-tool
pre-commit-tool:
	$(eval targets := $(onpy) $(onsh) $(onyml))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	find $(targets) -type f -regex $(REGEX_PY) -print0 | $(gnu_xargs) -0 pre-commit run $(PRE_COMMIT_FLAGS) --files; fi
