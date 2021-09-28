#This is an example top-level Makefile, inner Makefile-s would work similarly
SHELL := /bin/bash
# By default run multiple tools in parallel, when formatting  you may want to run "make -j1" to ensure formatters
# run sequentially
MAKEFLAGS += -j4

# Set PYTHONPATH
PY_SOURCES_ROOTS=app_iqor:app_paper_plane:lib_py_utils

# Aliases (short names given to one or more paths, can be used to define the default targets,)
iqor=app_iqor/
utils=lib_py_utils/py_utils lib_py_utils/test_utils
gen_script=build-support/python/packaging/generate_pip_install_files.py

# Default targets - for formatting, linting, type-checking, testing
ONPY=algo/ iqor app_paper_plane/ utils lib_bzl_utils/ gen_script  # References actual directories and/or aliases
ONSH=build-support/ deploy-support/ lib_sh_utils/
ONHS=tutorials_hs/scheme_interpreter
ONNB=notebooks/
ONMD=*.md app_* lib_* resources/
ONYML=.ci-azure/ build-support/ deploy-support/ .pre-commit-config.yaml

# Targets - for packaging (e.g. generation of requirements.txt files)
PY_LIBS=lib_py_utils/  # can be pip-install-ed
PY_APPS=app_paper_plane/ app_iqor/  # cannot be pip-installed
PY_PROJECTS=$(PY_LIBS) $(PY_APPS)
PY_LIB_NAMES=$(foreach path,$(utils),$(shell basename $(path)))  # to be able to pip uninstall

# Because some rules may be long, the Makefile is split in several smaller files (they all belong to the same namespace).
# It is recommended to keep all "nested" rules in this file if possible.

include build-support/make/core/resolver.mk  # Utilities to resolve targets

# Bash
include build-support/make/config/bash.mk
include build-support/make/core/bash/env.mk
include build-support/make/core/bash/format.mk
include build-support/make/core/bash/lint.mk
include build-support/make/core/bash/test.mk

.PHONY: fmt-sh lint-sh test-sh
fmt-sh: shfmt
lint-sh: shellcheck shfmt-check
test-sh: bats

# Python
include build-support/make/config/python.mk
include build-support/make/core/python/pythonpath.mk
#export MYPYPATH := $(PYTHONPATH)  # Uncomment to set MYPYPATH to be the same as PYTHONPATH
include build-support/make/core/python/env.mk
include build-support/make/extensions/python/env.mk  # Also include custom goals coming from make/extensions/
include build-support/make/core/python/format.mk
include build-support/make/core/python/lint.mk
include build-support/make/core/python/type-check.mk
include build-support/make/core/python/test.mk
include build-support/make/core/python/package.mk
include build-support/make/core/python/clean.mk
include build-support/make/core/python/pre-commit.mk

.PHONY: fmt-py fmt-check-py lint-py test-py clean-py
fmt-py: docformatter isort autoflake black flynt
fmt-check-py: autoflake-check docformatter-check isort-check black-check flynt-check
lint-py: mypy flake8 bandit fmt-check-py pylint
test-py: pytest
clean-py: clean-pyc clean-mypy clean-pytest clean-egg-info clean-build-utils

# Notebooks
include build-support/make/config/jupyter.mk
include build-support/make/core/jupyter/format.mk
include build-support/make/core/jupyter/lint.mk

.PHONY: fmt-nb fmt-check-nb lint-nb
fmt-nb: nbstripout jblack
fmt-check-nb: jblack-check
lint-nb: flake8-nb fmt-check-nb

# Haskell
include build-support/make/core/haskell/lint.mk
include build-support/make/core/haskell/clean.mk

.PHONY: lint-hs clean-hs
lint-hs: hlint
clean-hs: clean-hio

# YAML
include build-support/make/config/yaml.mk
include build-support/make/core/yaml/format.mk
include build-support/make/core/yaml/lint.mk

.PHONY: fmt-yml lint-yml
fmt-yml: dos2unix-yml
lint-yml: yamllint

# Markdown
include build-support/make/config/markdown.mk
include build-support/make/core/markdown/env.mk
include build-support/make/core/markdown/format.mk
include build-support/make/core/markdown/lint.mk

.PHONY: fmt-md lint-md
fmt-md: markdownlint-fmt
lint-md: markdownlint

# Cross-language BUILD goals
.PHONY: env-default-replicate env-default-upgrade fmt lint type-check test clean

env-default-replicate: env-py-default-replicate env-sh-default-replicate env-md-default-replicate
env-default-upgrade: env-py-default-upgrade env-sh-default-upgrade env-md-default-upgrade

fmt: fmt-py fmt-nb fmt-yml fmt-md fmt-sh

fmt-check: fmt-check-py fmt-check-nb

lint: lint-py lint-sh lint-nb lint-yml lint-md

type-check: mypy

test: test-py test-sh

clean: clean-py clean-hs

# OTHER ----------------------------------------------------------------------------------------------------------------
.PHONY: pre-commit install-pre-commit-hook uninstall-pre-commit-hook

# Run as `make pre-commit since=--cached`
pre-commit: lint pre-commit-tool

install-pre-commit-hook:
	cp build-support/git-hooks/pre-commit .git/hooks/

uninstall-pre-commit-hook:
	rm .git/hooks/pre-commit

rm-envs:
	rm -rf 3rdparty/md-env-ws/node_modules/ 3rdparty/sh-env-ws/node_modules/
