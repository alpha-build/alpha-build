# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/cristianmatache/alpha-build/
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

ifndef PRETTIER_BIN
	PRETTIER_BIN=prettier
endif

.PHONY: prettier-ts-check
prettier-ts-check:
	$(eval targets := $(onts))
	$(eval prettier := $(PRETTIER_BIN))
	if $(call lang,$(targets),$(REGEX_TS)); then \
	find $(targets) -type f -regex $(REGEX_TS) | $(gnu_xargs) --no-run-if-empty $(prettier) -c $(PRETTIER_FLAGS); fi;
