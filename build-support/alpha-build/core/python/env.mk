# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

.PHONY: env-py-default-replicate
env-py-default-replicate:  # With constraints for full reproducibility
	$(python) -m pip install --upgrade pip
	$(python) -m pip install \
	-c $(DEFAULT_PYTHON_ENV)/constraints.txt \
	-r $(DEFAULT_PYTHON_ENV)/requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/dev-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/mypy-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/nb-requirements.txt

.PHONY: env-py-default-upgrade
env-py-default-upgrade:  # Without constraints to allow pip to resolve deps again
	$(python) -m pip install --upgrade pip setuptools
	$(python) -m pip install \
	-r $(DEFAULT_PYTHON_ENV)/requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/dev-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/mypy-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/nb-requirements.txt
	pip list --format=freeze > $(DEFAULT_PYTHON_ENV)/constraints.txt
	pip check
