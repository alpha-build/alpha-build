# find .. --exec always has exit code 0 -> use find | xargs
promtool-check-rules:
	$(eval targets := $(onprometheus-rules))
	$(eval promhome := $(shell source lib_sh_utils/src/commands.sh && find_command_home prometheus ~/prometheus PROMETHEUS_HOME))
	if $(call lang,$(targets),".*prometheus/rules.*\.yml"); then \
	find $(targets) -type f -regex ".*prometheus/rules.*\.yml" | xargs --no-run-if-empty "$(promhome)/promtool" check rules; fi
