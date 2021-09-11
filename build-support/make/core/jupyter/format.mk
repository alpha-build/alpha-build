# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/cristianmatache/alpha-build/
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/make/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/make/extensions/<lang>/ and import it in the main Makefile

.PHONY: jblack
jblack:
	$(eval targets := $(onnb))
	if $(call lang,$(targets),$(REGEX_NB)); then \
  	python -m jupyterblack $(JUPYTERBLACK_FLAGS) $(targets); fi

.PHONY: nbstripout
nbstripout:
	$(eval targets := $(onnb))
	if $(call lang,$(targets),$(REGEX_NB)); then \
  	find $(targets) -type f -name "*.ipynb" -print | xargs python -m nbstripout $(NBSTRIPOUT_FLAGS); fi
