# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/cristianmatache/workspace
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/make/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/make/extensions/<lang>/ and import it in the main Makefile

.PHONY: clean-pyc
clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

.PHONY: clean-pytest
clean-pytest:
	find . -name .pytest_cache -type d -exec rm -rf {} +
	find . -name .hypothesis -type d -exec rm -rf {} +

.PHONY: clean-mypy
clean-mypy:
	rm -rf .mypy_cache

.PHONY: clean-egg-info
clean-egg-info:
	find . -name .hypothesis -type d -exec rm -rf {} +
