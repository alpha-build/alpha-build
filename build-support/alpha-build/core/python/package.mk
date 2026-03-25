# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

.PHONY: pipreqs
pipreqs:
	$(eval targets := $(onpy))
	@if $(call lang,$(targets),$(REGEX_PY)); then  \
  	for target in $(targets); do pipreqs $(PIPREQS_FLAGS) $$target; done; fi

.PHONY: pip-install-local
pip-install-local:
	pip install --no-deps --upgrade $(PY_LIBS)

.PHONY: pip-uninstall-local
pip-uninstall-local:
	pip uninstall -y $(PY_LIB_NAMES)
