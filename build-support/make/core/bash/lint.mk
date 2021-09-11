# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/cristianmatache/alpha-build/
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/make/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/make/extensions/<lang>/ and import it in the main Makefile

# find .. --exec always has exit code 0 -> use find | xargs
.PHONY: shellcheck
shellcheck:
	$(eval targets := $(onsh))
	if $(call lang,$(targets),$(REGEX_SH)); then \
	find $(targets) -type f -iname "*.sh" | xargs shellcheck $(SHELLCHECK_FLAGS); fi

.PHONY: shfmt-check
shfmt-check:
	$(eval targets := $(onsh))
	if $(call lang,$(targets),$(REGEX_SH)); then \
	shfmt -d $(SHFMT_FLAGS) $(targets); fi
