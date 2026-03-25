# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

ifndef DEFAULT_PYTEST_MARKS
	DEFAULT_PYTEST_MARKS=""
endif

ifndef DEFAULT_PYTEST_CASES
	DEFAULT_PYTEST_CASES=""
endif

.PHONY: pytest
pytest:
	$(eval targets := $(onpy))
	$(eval marks := $(DEFAULT_PYTEST_MARKS))
	$(eval cases := $(DEFAULT_PYTEST_CASES))
	if $(call lang,$(targets),$(REGEX_PY)); then \
	$(python) -m pytest --rootdir=. -m $(marks) -k $(cases) $(PYTEST_FLAGS) $(targets); fi  # Add pytest-cov to flags for coverage
