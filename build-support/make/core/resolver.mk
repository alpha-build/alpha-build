# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/cristianmatache/alpha-build/
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/make/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/make/extensions/<lang>/ and import it in the main Makefile

# File extension regexes
REGEX_PY=".*\.pyi?"
REGEX_SH=".*\.sh"
REGEX_HS=".*\.hs"
REGEX_NB=".*\.ipynb"
REGEX_MD=".*\.md"
REGEX_YML=".*\.ya?ml"
REGEX_JS=".*\.js"
REGEX_TS=".*\.ts"
REGEX_HTML=".*\.html"
REGEX_CSS=".*.\.css"
REGEX_RST=".*.\.rst"

# OS handling for environments
# Don't run these with $(shell ...) here because it may result in slowness, use $(shell $(IS_WINDOWS_CMD)) at the point of use
IS_WINDOWS_CMD=uname | egrep -i "msys"            # Non-empty if is windows cmd
IS_WINDOWS_GIT_BASH=uname | egrep -i "mingw|NT-"  # Non-empty if is windows git bash
IS_MAC=uname | egrep -i "darwin"                  # Non-empty if is mac

ifneq ($(shell command -v gfind),)  # is MacOS (mostly)
gnu_find=gfind
else
gnu_find=find
endif

# If "on" was supplied as an alias -> solve the alias, otherwise pass in the raw on
# Args:
#	- $1: named file/dir target(s) specifier (i.e. the "on")
solve_aliases = $(foreach target,$(foreach dir, $1, $(or ${$(dir)},${dir},$1)),$(call sanitize,${target}))

# Sanitize double/single/no quotes
ifneq ($(shell $(IS_WINDOWS_CMD)),)  # is cmd
sanitize = $(foreach target,$(shell echo $1 | tr '\\\\\\\\' '/' | tr -d "'" | tr -d '"' ),"$(target)")
else  # is Unix or Git bash
sanitize = $1
endif

# Only run the command if the "on" specs are suitable for the expected language
# Args:
#   - $1: "on" specifier
#   - $2: file extension regex e.g. ".*\.pyi?" or ".*\.sh"
# Same as:
#	lang = [[ ! -z "$1" ]] && [[ ! -z `find $(call solve_aliases,$1) -type f -regex $2` ]]
# but does not expand such that generated commands are not huge
lang = [[ ! -z $(if $(shell echo "$1"),$(if $(shell $(gnu_find) $(call solve_aliases,$1) -type f -regex $2),'true',''),'') ]]

# Finds the intersection of the given directories with the given files.
# That is, returns all files in $2 that belong to the directories in $1
# Args:
#	- $1: a list of directories separated by spaces (as this is bash)
#   - $2: a list of files (paths starting from repo root)
intersect_files = $(shell $(gnu_find) $(call solve_aliases,$1) $(foreach file,$2, -wholename $(file) -o) -wholename XYZ)

# NOTE 1: Does not work if the command built is longer than `getconf ARG_MAX` characters
# Especially relevant when running with since=... (e.g. since=HEAD~10000) over all the files (no on=...)
# NOTE 2: Does not work if paths/file names contain spaces, XYZ is some file that does not exist, used to have a value for the final -o
ifneq ($(since),)
	# Filter git diff --name-only output for the right extension and find the path in the original targets such that we:
	# 1. ensure the files exist (git diff --name-only also reports files that were deleted)
	# 2. ensure we only run the checks over the targets listed in the global $(ON<lang>) not across any changed <lang> file
	since_py=$(shell  git diff --name-only $(since) | grep -E $(REGEX_PY) | grep -v ".pylintrc")
	since_sh=$(shell  git diff --name-only $(since) | grep -E $(REGEX_SH))
	since_hs=$(shell  git diff --name-only $(since) | grep -E $(REGEX_HS))
	since_nb=$(shell  git diff --name-only $(since) | grep -E $(REGEX_NB))
	since_md=$(shell  git diff --name-only $(since) | grep -E $(REGEX_MD))
	since_yml=$(shell git diff --name-only $(since) | grep -E $(REGEX_YML))
	since_js=$(shell git diff --name-only $(since) | grep -E $(REGEX_JS))
	since_ts=$(shell git diff --name-only $(since) | grep -E $(REGEX_TS))
	since_html=$(shell git diff --name-only $(since) | grep -E $(REGEX_HTML))
	since_css=$(shell git diff --name-only $(since) | grep -E $(REGEX_CSS))
	since_rst=$(shell git diff --name-only $(since) | grep -E $(REGEX_RST))
	ifneq ($(on),)
		# Run over all the files change since=... that appear in the defaults (i.e. in the ON<LANG> variables)
		onpy=$(call   intersect_files,$(call solve_aliases,$(on)),$(since_py))
		onsh=$(call   intersect_files,$(call solve_aliases,$(on)),$(since_sh))
		onhs=$(call   intersect_files,$(call solve_aliases,$(on)),$(since_hs))
		onnb=$(call   intersect_files,$(call solve_aliases,$(on)),$(since_nb))
		onmd=$(call   intersect_files,$(call solve_aliases,$(on)),$(since_md))
		onyml=$(call  intersect_files,$(call solve_aliases,$(on)),$(since_yml))
		onjs=$(call   intersect_files,$(call solve_aliases,$(on)),$(since_js))
		onts=$(call   intersect_files,$(call solve_aliases,$(on)),$(since_ts))
		onhtml=$(call intersect_files,$(call solve_aliases,$(on)),$(since_html))
		oncss=$(call  intersect_files,$(call solve_aliases,$(on)),$(since_css))
		onrst=$(call  intersect_files,$(call solve_aliases,$(on)),$(since_rst))
	else
		# Run over all the files change since=... that also belong to the defaults (i.e. in the ON<LANG> variables)
		# (results in different targets for each language)
		onpy=$(call   intersect_files,$(call solve_aliases,$(ONPY)),$(since_py))
		onsh=$(call   intersect_files,$(call solve_aliases,$(ONSH)),$(since_sh))
		onhs=$(call   intersect_files,$(call solve_aliases,$(ONHS)),$(since_hs))
		onnb=$(call   intersect_files,$(call solve_aliases,$(ONNB)),$(since_nb))
		onmd=$(call   intersect_files,$(call solve_aliases,$(ONMD)),$(since_md))
		onyml=$(call  intersect_files,$(call solve_aliases,$(ONYML)),$(since_yml))
		onjs=$(call   intersect_files,$(call solve_aliases,$(ONJS)),$(since_js))
		onts=$(call   intersect_files,$(call solve_aliases,$(ONTS)),$(since_ts))
		onhtml=$(call intersect_files,$(call solve_aliases,$(ONHTML)),$(since_html))
		oncss=$(call  intersect_files,$(call solve_aliases,$(ONCSS)),$(since_css))
		onrst=$(call  intersect_files,$(call solve_aliases,$(ONRST)),$(since_rst))
	endif
else
	ifneq ($(on),)
		# Run over the targets specified in on=...
		# (results in the same targets for all languages)
		# It is better not to enumerate all the files because if "on" comprises many many files we may hit the limit
		onpy=$(call  solve_aliases,$(on))
		onsh=$(call  solve_aliases,$(on))
		onhs=$(call  solve_aliases,$(on))
		onnb=$(call  solve_aliases,$(on))
		onmd=$(call  solve_aliases,$(on))
		onyml=$(call solve_aliases,$(on))
		onjs=$(call solve_aliases,$(on))
		onts=$(call solve_aliases,$(on))
		onhtml=$(call solve_aliases,$(on))
		oncss=$(call solve_aliases,$(on))
		onrst=$(call solve_aliases,$(on))
	else
		# Run over the default targets
		# (results in different targets for each language)
		onpy=$(call   solve_aliases,$(ONPY))
		onsh=$(call   solve_aliases,$(ONSH))
		onhs=$(call   solve_aliases,$(ONHS))
		onnb=$(call   solve_aliases,$(ONNB))
		onmd=$(call   solve_aliases,$(ONMD))
		onyml=$(call  solve_aliases,$(ONYML))
		onjs=$(call   solve_aliases,$(ONJS))
		onts=$(call   solve_aliases,$(ONTS))
		onhtml=$(call solve_aliases,$(ONHTML))
		oncss=$(call  solve_aliases,$(ONCSS))
		onrst=$(call  solve_aliases,$(ONRST))
	endif
endif


# !!! Example goal implementation explained !!!
#
# Check if there are any python files in the targets (after aliases were resolved)
# if yes, run the tool over the targets
# MYPY_FLAGS is defined in build-support/make/config/.
#
# To change them dynamically at run-time run as:
# make _example-goal MYPY_FLAGS="--config-file my-new-mypy.ini"
#
# If you want to re-use the same goal within another Makefile (not the top level), the MYPY_FLAGS variable can be
# overriden in the inner Makefile (not the top-level one).
.PHONY: _example-goal
_example-goal:
	$(eval targets := $(onpy))  # Same as: targets = onpy if targets is None else targets
	if $(call lang,$(targets),$(REGEX_PY)); then  \
	python -m mypy $(MYPY_FLAGS) $(targets); fi
