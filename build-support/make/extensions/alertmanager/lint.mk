# find .. --exec always has exit code 0 -> use find | xargs
amtool-check-config:
	$(eval targets := $(onam))
	$(eval amhome := $(shell source lib_sh_utils/src/commands.sh && find_command_home alertmanager ~/alertmanager/ ALERTMANAGER_HOME))
	if $(call lang,$(targets),".*alertmanager/.*\.yml"); then \
	find $(targets) -type f -regex ".*alertmanager.*\.yml" | xargs --no-run-if-empty "$(amhome)/amtool" check-config; fi
