# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/alpha-build/alpha-build
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/alpha-build/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/alpha-build/extensions/<lang>/ and import it in the main Makefile

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
REGEX_SWIFT=".*.\.swift"
REGEX_KT=".*.\.kt"

# OS handling for environments
# Don't run these with $(shell ...) here because it may result in slowness, use $(shell $(IS_WINDOWS_CMD)) at the point of use
IS_WINDOWS_CMD=uname | egrep -i "msys"            # Non-empty if is windows cmd
IS_WINDOWS_GIT_BASH=uname | egrep -i "mingw|NT-"  # Non-empty if is windows git bash
IS_MAC=uname | egrep -i "darwin"                  # Non-empty if is mac
IS_LINUX=uname | egrep -i "linux"                 # Non-empty if is linux

# By default use "python" to call python, but sometimes one may need to invoke tools differently
python=python
# In case you want to invoke python tools differently (e.g., python3, or via poetry run) please change the way python
# is called something. For example:
# 1. For poetry add this to your Makefile (after including the resolver.mk file)
# 	python=poetry run python
# 2. For python3 on Linux, add this to your Makefile (after including the resolver.mk file)
#	ifneq ($(shell $(IS_LINUX),)  # is Linux
#	python=python3
#	endif

ifneq ($(shell command -v gfind),)  # is MacOS (mostly)
gnu_find=gfind
else
gnu_find=find
endif

ifneq ($(shell command -v gxargs),)  # is MacOS (mostly)
gnu_xargs=gxargs
else
gnu_xargs=xargs
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
# NOTE 1: Does not work if paths/file names contain spaces, XYZ is some file that does not exist, used to have a value
#			for the final -o
# NOTE 2: It is safer to use find ... -wholename ... with full paths because otherwise find prepends the find argument
#			to the result that we are filtering for. That is, find . -wholename README.md does not return anything but
#			find . -wholename ./README.md does.
intersect_paths = $(shell $(gnu_find) $(shell realpath $1) $(foreach file,$2, -wholename $(shell realpath $(file)) -o) -wholename XYZ | $(gnu_xargs) --no-run-if-empty realpath --relative-to=.)
intersect_files = $(call intersect_paths,$(call solve_aliases,$1),$2)

# Function:
# 	- resolve_since (only defined if since=<git-revision> is provided from the console)
# Description:
#	- Filter git diff --name-only output for the right file extension
# Args
# 	- $1: language regex

# Function:
#	- resolve_targets
# Description:
#	- Resolve on=... since=... to a list of target files/directories per language
# Args:
# 	- $1: language regex
# 	- $2: default targets e.g. $(ONPY)
# 	- $3: function that filters out targets (files or dirs), by default nothing is filtered out
# NOTE 1: Does not work if the command built is longer than `getconf ARG_MAX` characters
#         Especially relevant when running with since=... (e.g. since=HEAD~10000) over all the files (no on=...)
# NOTE 2: intersect_files would:
#         - ensure the target files exist (git diff --name-only also reports files that were deleted)
#         - ensure we only run the checks over the targets listed in the global $(ON<lang>) not across any changed <lang> file

ifndef _DEFAULT_TARGETS
	_DEFAULT_TARGETS=.
endif

ifneq ($(since),)
	resolve_since=$(shell git diff --name-only $(since) | grep -E $1)
	ifneq ($(on),)
		# Run over all the files change since=... that appear in on=...
		# (results in different targets for each language)
		resolve_targets=$(call intersect_files,$(call solve_aliases,$(on)),$(call $3,$(call resolve_since,$1)))
		resolve_pre_commit_targets=--files $(call resolve_targets,$1,$(or $2,$(_DEFAULT_TARGETS)),$3)
	else
		# Run over all the files change since=... that appear in the defaults (i.e. in the ON<LANG> variables)
		# (results in different targets for each language)
		resolve_targets=$(call intersect_files,$(call solve_aliases,$(or $2,$(_DEFAULT_TARGETS))),$(call $3,$(call resolve_since,$1)))
		resolve_pre_commit_targets=--files $(call resolve_targets,$1,$(or $2,$(_DEFAULT_TARGETS)),$3)
	endif
else
	ifneq ($(on),)
		# Run over the targets specified in on=...
		# (results in the same targets for all languages)
		# It is better not to enumerate all the files because if "on" comprises many many files we may hit the limit
		resolve_targets=$(call $3,$(call solve_aliases,$(on)))
		resolve_pre_commit_targets=--files $(call $3,$(shell $(gnu_find) $(call solve_aliases,$(on)) -type f))
	else
		# Run over the default targets
		# (results in different targets for each language)
		resolve_targets=$(call $3,$(call solve_aliases,$(or $2,$(_DEFAULT_TARGETS))))
		resolve_pre_commit_targets=--all-files
	endif
endif

id_func=$1
py_exclude=$(filter-out %.pylintrc,$1)

onpy=$(call resolve_targets,$(REGEX_PY),$(ONPY),py_exclude)  # Resolved Python targets
onsh=$(call resolve_targets,$(REGEX_SH),$(ONSH),id_func)
onhs=$(call resolve_targets,$(REGEX_HS),$(ONHS),id_func)
onnb=$(call resolve_targets,$(REGEX_NB),$(ONNB),id_func)
onmd=$(call resolve_targets,$(REGEX_MD),$(ONMD),id_func)
onyml=$(call resolve_targets,$(REGEX_YML),$(ONYML),id_func)
onjs=$(call resolve_targets,$(REGEX_JS),$(ONJS),id_func)
onts=$(call resolve_targets,$(REGEX_TS),$(ONTS),id_func)
onhtml=$(call resolve_targets,$(REGEX_HTML),$(ONHTML),id_func)
oncss=$(call resolve_targets,$(REGEX_CSS),$(ONCSS),id_func)
onrst=$(call resolve_targets,$(REGEX_RST),$(ONRST),id_func)
onswift=$(call resolve_targets,$(REGEX_SWIFT),$(ONSWIFT),id_func)
onkt=$(call resolve_targets,$(REGEX_KT),$(ONKT),id_func)
onprecommit=$(call resolve_pre_commit_targets,"*",.,id_func)  # Default targets are defined in .pre-commit-config.yaml


# !!! Example goal implementation explained !!!
#
# Check if there are any python files in the targets (after aliases were resolved)
# if yes, run the tool over the targets
# MYPY_FLAGS is defined in build-support/alpha-build/config/.
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
	$(python) -m mypy $(MYPY_FLAGS) $(targets); fi
