# UNUSED !!!!!

# Subsystems (i.e. inner projects with their own Makefiles)
subsystems=""

# smart_command explanation:
# What: if the targets belong to some subsystem, forward them to the inner makefile rule, else use the global one
# Why: if we need nested Makefile-s (normally it would be better to use the config files per sub-project)
# How:
# 1. expand aliases passed in "on/since" if any (i.e. $2)
# 2. work out which target directories/files belong to subsystems (inner makefiles) such that we forward the make rule
# 3. smart_command is passed the actual command ($1) apart from the file/dir targets ($2) (which will be appended)
#		- for each subsystem work out which files actually belong to it
# 		- if a whole subsystem is passed but no files/dirs inside it -> make inner makefile without "on"s to use the
#		  defaults in that makefile
# 	    - if files/subdirs of a subsystem are passed in forward them as "on"-s and remove the base path
# 		  hence there will be no problems with cd
define smart_command
	$(eval resolved_on := $2)
	$(eval to_make := $(foreach subsystem,$(subsystems),$(filter-out $(subsystem)%, $(resolved_on))))
	$(eval to_delegate := $(foreach subsystem,$(subsystems),$(filter $(subsystem)%, $(resolved_on))))
	command=$1; \
	if [[ "$(to_make)" != "" ]]; then \
		to_eval="$${command/\"/} $(to_make)"; \
		echo "!!!!!! EVALUATING: $$to_eval"; \
		eval "$$to_eval"; \
	fi \
	&& \
	if [[ "$(to_delegate)" != "" ]]; then \
		for subsystem in $(subsystems); do \
			dirs=""; \
			for dir in $(to_delegate); do \
				if [[ $$dir == $$subsystem* ]]; then dirs="$${dir/$$subsystem\//} $$dirs"; fi; \
			done; \
			if [[ "$$dirs" == "" ]]; then \
				to_eval='"$(MAKE)" $@ -C "$$subsystem"'; \
				echo "!!!!!! EVALUATING in $$subsystem: $$to_eval"; \
				eval "$$to_eval"; \
			else \
				echo "!!!!!! EVALUATING in $$subsystem: \"$(MAKE)\" $@ on=\"$$dirs\" -C \"$$subsystem\""; \
				"$(MAKE)" $@ on="$$dirs" -C "$$subsystem"; \
			fi; \
		done; \
	fi
endef
