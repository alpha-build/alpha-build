# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

.PHONY: autoflake-check
autoflake-check:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m autoflake --in-place $(AUTOFLAKE_FLAGS) --check -r $(targets); fi

.PHONY: docformatter-check
docformatter-check: docformatter-diff docformatter-actual-check

.PHONY: docformatter-actual-check
docformatter-actual-check:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m docformatter $(DOCFORMATTER_FLAGS) --check -r $(targets); fi

.PHONY: docformatter-diff
docformatter-diff:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m docformatter $(DOCFORMATTER_FLAGS) -r $(targets); fi

.PHONY: isort-check
isort-check:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m isort --check-only --diff --color $(ISORT_FLAGS) $(targets); fi

.PHONY: black-check
black-check:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m black --check $(BLACK_FLAGS) $(targets); fi

.PHONY: flynt-check
flynt-check:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m flynt --dry-run --fail-on-change $(FLYNT_FLAGS) $(targets); fi

.PHONY: flake8
flake8:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m flake8 $(FLAKE8_FLAGS) $(targets); fi

.PHONY: bandit
bandit:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m bandit $(BANDIT_FLAGS) -r $(targets); fi

.PHONY: pylint
pylint:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m pylint $(PYLINT_FLAGS) $(targets); fi

.PHONY: pydocstyle
pydocstyle:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
  	$(python) -m pydocstyle $(PYDOCSTYLE_FLAGS) $(targets); fi

.PHONY: ruff-format-check
ruff-format-check:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m ruff format --check --diff $(RUFF_FLAGS) $(targets); fi

.PHONY: ruff-lint-check
ruff-lint-check:
	$(eval targets := $(onpy))
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	$(python) -m ruff check $(RUFF_FLAGS) $(targets); fi
