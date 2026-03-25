# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

.PHONY: clean-pyc
clean-pyc:
	find . -name *.pyc | $(gnu_xargs) rm -f && find . -name *.pyo | $(gnu_xargs) rm -f;

.PHONY: clean-pytest
clean-pytest:
	find . -name .pytest_cache -type d -exec rm -rf {} +
	find . -name .hypothesis -type d -exec rm -rf {} +

.PHONY: clean-mypy
clean-mypy:
	rm -rf .mypy_cache

.PHONY: clean-egg-info
clean-egg-info:
	find . -name "*.egg-info" -type d -exec rm -rf {} +

.PHONY: clean-whl
clean-whl:
	find . -name "*.whl" -type f -exec rm -rf {} +

.PHONY: clean-bdist
clean-bdist:
	find . -name "bdist*" -type d -exec rm -rf {} +

.PHONY: clean-pycache
clean-pycache:
	find . -name __pycache__ -type d -exec rm -rf {} +

.PHONE: clean-ruff
clean-ruff:
	rm -rf .ruff_cache

.PHONY: clean-numba
clean-numba:
	$(eval targets := $(onpy))
	find $(targets) -type f -name *.nb? -print0 | $(gnu_xargs) -0 rm -f;
