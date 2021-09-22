# Here, prometheus.yml file act as a different language altogether that is not supported out of the box
# by AlphaBuild core. So, we have 2 choices for this extension:
# 1. Extend the resolver.mk logic (in extensions/resolver.mk not in core/resolver.mk !!) to work out what
#    $(onprometheus-rules) should be similarly to the way we work out $(onpy) for example,
#    and we would do $(eval targets := $(onprometheus-rules)) since the "on" is what the user passes directly
# 2. Use the "on" specified by the user directly, with some default value if no on is specified. (see implementation below)
# Note: find .. --exec always has exit code 0 -> use find | xargs
promtool-check-rules:
	$(eval on := $(onprometheus-rules))
	$(eval promhome := $(shell source lib_sh_utils/src/commands.sh && find_command_home prometheus ~/prometheus PROMETHEUS_HOME))
	if $(call lang,$(on),".*prometheus/rules.*\.yml"); then \
	find $(call solve_aliases,$(on)) -type f -regex ".*prometheus/rules.*\.yml" | xargs --no-run-if-empty "$(promhome)/promtool" check rules; fi
