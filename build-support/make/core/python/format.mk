# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/cristianmatache/alpha-build/
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/make/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/make/extensions/<lang>/ and import it in the main Makefile

.PHONY: docformatter
docformatter:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	python -m docformatter --in-place $(DOCFORMATTER_FLAGS) -r $(targets); fi

.PHONY: isort
isort:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	python -m isort $(ISORT_FLAGS) $(targets); fi

.PHONY: autoflake
autoflake:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	python -m autoflake --in-place $(AUTOFLAKE_FLAGS) -r $(targets); fi

.PHONY: black
black:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	python -m black $(BLACK_FLAGS) $(targets); fi

.PHONY: flynt
flynt:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	python -m flynt $(FLYNT_FLAGS) $(targets); fi
