# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

.PHONY: jblack-check
jblack-check:
	$(eval targets := $(onnb))
	if $(call lang,$(targets),$(REGEX_NB)); then \
  	$(python) -m jupyterblack --check $(JUPYTERBLACK_FLAGS) $(targets); fi

.PHONY: flake8-nb
flake8-nb:
	$(eval targets := $(onnb))
	if $(call lang,$(targets),$(REGEX_NB)); then \
  	find $(targets) -type f -iname "*.ipynb" | $(gnu_xargs) $(python) -m flake8_nb $(FLAKE8_NB_FLAGS); fi
