.PHONY: rstcheck
rstcheck:
	$(eval targets := $(onrst))
	if $(call lang,$(targets),$(REGEX_RST)); then  \
	find $(targets) -type f -regex $(REGEX_RST) -print0 | $(gnu_xargs) -0 python -m rstcheck $(RSTCHECK_FLAGS); fi
