# Workspace

A monorepo containing some of my small projects powered by a scalable build system. See individual README.md files for
more details.

[![Build Status](https://dev.azure.com/cristianmatache/workspace/_apis/build/status/cristianmatache.workspace?branchName=master)](https://dev.azure.com/cristianmatache/workspace/_build/latest?definitionId=1&branchName=master)
[![Python 3.8+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![Checked with mypy](http://www.mypy-lang.org/static/mypy_badge.svg)](http://mypy-lang.org/)
![pylint Score](https://mperlet.github.io/pybadge/badges/10.svg)

## Contents

- **build-support:** Makefile library inspired by Pants/Bazel to run linters, formatters, test frameworks, type
  checkers, packers etc. on a variety of languages (Python, Jupyter Notebooks, Bash, Haskell, YAML, Markdown) → make
- **app_iqor:** IQOR = I Quit Ordinary Renting (HackZurich 2019) → Q/KDB+Python
- **app_paper_plane:** Paper Plane = find same flight but cheaper by changing country on Skyscanner (LauzHack 2018) →
  Python
- **dotfiles:** my take-everywhere rc-files
- **lib_bzl_utils:** useful macros for Bazel → Starlark
- **lib_py_utils:** a few interesting general purpose utility functions → Python
- **tutorials_hs:**
  - h99: see <https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems> → Haskell
  - scheme interpreter: see <https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours> → Haskell
- **tutorials_q:**
  - weekly_q: see <https://dpkwhan.github.io/weeklyq/> → Q/KDB

## Hackathon projects

For more hackathon projects see my devpost accounts:

- <https://devpost.com/crm15>
- <https://devpost.com/cristianmatache>

Some projects will be ported over here, some others are lost somewhere in space and time.

## Makefile (mainly for scripting and config languages)

The way the Makefile of this project works draws inspiration heavily from monorepo build tools such as Pants, Bazel,
Buck. It runs multiple linters, formatters, type checkers, hermetic packers, testing frameworks, virtual environment
managers etc. It works on Linux, WSL and Windows with Git Bash (for Windows please
run  `build-support/git-bash-integration/install_make.sh` running Git Bash as administrator).

### Usage

Usually to format, lint, type-check, test, package, ... the code, one needs to run a bunch of commands in the terminal,
setting the right flags and the right parameters. This Make-based build system helps with running these commands with
a very simple interface: `make <goal> <optional-targets>` where **goal = what tools we run** and
**targets = over which files we run these tools**.

#### Goals - what tools we run

Goals mean what command line tools to run. This build system can run one more tools at once as follows:

- *Individual* tool
  - e.g. `make mypy`, `make flake8`, `make isort`
- Multiple tools for a *specific* language
  - e.g. `make fmt-py` runs all Python formatters `isort`, `black`, `docformatter`, `flynt`, `autoflake`
  - e.g. `make fmt-sh` runs shfmt
  - e.g. `make lint-py` runs all Python linters and formatters in "verification" mode - `flake8` + `pylint` + check
    whether the code is already formatted with `isort`, `black`, `docformatter`, `flynt`, `autoflake`
  - `make fmt-md`, `make lint-yml`, `test-sh`, `test-py` ... work similarly
- Multiple tools for *multiple* languages
  - e.g. `make fmt` runs all formatters for all supported languages (Python, Bash, Markdown, YAML, ...)
  - e.g. `make lint` runs all linters for all supported languages
  - e.g. `make test` runs all test suites for all supported languages

It is possible to run multiple goals at once like `make lint test`. In addition, it is very easy to change the meaning
of goals that run more than one command since they are very simply defined in Make based on other goals. For example,
one can remove the `shfmt` from bash linting simply by doing the below:  

```makefile
# Before
lint-sh: shellcheck shfmt-check  # where shellcheck and shfmt-check run the respective commands
# After
lint-sh: shellcheck
```

Per-tool config files (e.g. `mypy.ini`, `pyproject.toml`) are found in `build-support/<language>/tools-config/`.

##### Targets - what files we run the tools on

We have seen that Make gives us the power to run multiple terminal commands effortlessly. Using a Makefile like
described above is standard practice in many projects, typically running the different tools over all their files.
However, as projects grow, the need to run these tools at different granularities (e.g. in a specific directory,
over a given file, on the diff between two branches, since we last committed etc). This is where targets come into play.

- **without targets:**
  - `make lint` runs:
    - all Python linters on all directories (in the `$ONPY`) that contain Python/stub files.
    - all notebook linters on all directories (in `$ONNB`) that contain .ipynb files.
    - all Bash linters (shellcheck) on all directories (in `$ONSH`) that contain Bash files.
    - a Haskell linter (hlint) on all directories (in `$ONHS`) that contain Haskell files.
    - a YAML linter (yamllint) on all directories (in `$ONYML`) that contain YAML files.
  - `make lint`, `make fmt -j1`, `make type-check` work similarly
  - the `$(ONPY)`, `$(ONSH)`, ... variables are defined at the top of the Makefile and represent the default locations
      where to search for files certain languages.
- **with specific targets:**
  - file: `make lint on=app_iqor/server.py` runs all Python linters on the file, same
      as `make lint-py on=app_iqor/server.py`
  - directory: `make lint on=lib_py_utils` runs a bunch of linters on the directory, in this case, same
      as `make lint-py on=lib_py_utils/`.
  - files/directories: `make lint on="lib_py_utils app_iqor/server.py"` runs a bunch of linters on both targets.
  - globs: `make lint on=lib_*`
  - aliases: `make fmt on=iqor` is the same as `make fmt on=app_iqor/` because `iqor` is an alias for `app_iqor/`. Even
      though this example is simplistic, it is useful to alias combinations of multiple files/directories. It is
      recommended to set aliases as constants in the Makefile even though environment variables would also work.
  - same for `make fmt`, `make test`, `make type-check`.
- **with git revision targets:**
  - `make fmt -j1 since=master` runs all formatters on the diff between the current branch and master.
  - `make fmt -j1 since=HEAD~1` runs all formatters on all files that changed since "2 commits ago".
  - `make lint since=--cached` runs all linters on all files that are "git added".
  - all goals that support the "on" syntax also support the "since" syntax

#### Constraints

Different languages may have different goals, for example Python can be packaged hermetically with Shiv, while Bash
obviously can't.

The following goals must support the "on" and "since" syntax and ensure that they are only run if there are any targets
for the language they target:

- format
- lint
- type-check
- test

If you want to learn more about the API of a specific goal, check the source code.

#### Common admin actions

- **Change what goal-lang does:** Let's say, for example, you don't want to run `pylint` as part of your python
linting. You would simply go to the `Makefile` and change the definition of the `lint-py` goal to not include `pylint`.
- **Adding goals:** The goals that are available out of the box are found in `build-support/make/core/<language>/`.
You can extend/replace the core goals for new languages and/or tools by writing `.mk` code in
`build-support/make/extensions/<language>/` following the examples in `build-support/make/core/`.
- **Update the PYTHONPATH:** The PYTHONPATH is set at the top of the `Makefile`. For example, to add new directories to
the PYTHONPATH (i.e. to mark them as sources roots) set `PY_SOURCES_ROOTS` at the top of the Makefile.
- **See/Change tools config:** Let's say you want to change the way `mypy` is configured to exclude some directory from
checking. Then head to `build-support/make/config/python.mk` check what is the path to the `mypy` config file, go there
and update it. All other tools work similarly.
- **Third party environments**
  - **Exact reproduction of the default environment:** The recipes to fully replicate the default environment
  (mostly using `pip`, `conda` and `npm`) are found in `build-support/make/core/<langugage>/setup.mk`, where they use
  dependency files and lock files that can be found in `3rdparty/`. In practice, run `make env-default-replicate` inside
  a conda environment. Also make sure you also have `npm` installed because `markdownlint` and `bats` bash testing
  framework come from `npm` (if you don't need them no need to worry about `npm` just exclude the `markdown`
  environment rule from the pre-requisites of `env-default-replicate`)
  - **Create/Upgrade/Edit default environment:** If you want to edit the default environment, for example to add,
  remove, constrain packages edit the `requirements.txt` not the `constraints.txt` file (in `3rdparty/`).
  The `constraints.txt` is only used for reproducibility. If you just want to upgrade your third party dependencies
  there is no need to temper with the `requirements.txt` files. Then run `make env-default-upgrade` and check the lock
  files back into git.
  - **Add a new environment:** To add a new environment, first add the dependency files (e.g. `requirements.txt`) in
  `3rdparty/<new-env-name>`, add a new goal in `build-support/make/extensions`. For environment management over time, we
  strongly encourage maintaining the approach split between creation/upgrade/edit and exact reproduction of
  environments.
- **Nested makefiles:** Supposing you want to have another `Makefile` for a specific project in the monorepo, just
import everything that you need from `build-support/make/core/` and/or `build-support/make/extensions/`. To change the
Now let's say you want to use a different config file for `mypy`. You would have 2 options, either change the path
globally `build-support/make/config/python.mk` or, if you just want different settings for your little project use
your inner `Makefile` to overwrite the value of the corresponding variable (that points to the config file) with the
different path.
- **Generate requirements.txt for each sub-project:** Run `make reqs-py`.
- **Generate setup.py for each sub-project:** Run `build-support/python/packaging/generate_pip_install_files.py`

### Installation

To add this build system to an existing repo, one needs to simply copy `build-support/` and `3rdparty/` over.
Run `make env-default-replicate`, as a one-off, to set up the python, markdown and bash environments
(mostly pip/npm install-s). It is recommended to copy over `lib_sh_utils/` and `deploy-support/` if you need support
for Prometheus, Alertmanager or Grafana. In addition, if renaming directories in `3rdparty/` the correspondent paths in
`build-support/make/config/<lang>.mk` should also be updated.

To upgrade an existing installation if new tools are added or changes are made to the target resolution infrastructure,
one would simply need to copy over `lib-support/make/core`.

### Supported tools by language

- Python:
  - Setup: `pip` / `conda`
  - Type-check: `mypy`
  - Test: `pytest`
  - Format + Lint: `black`, `docformatter`, `isort`, `autoflake`, `flynt`, `pre-commit`
  - Lint only: `flake8`, `pylint`, `bandit`
  - Package: `pipreqs`, `shiv`
- Jupyter:
  - Setup: `pip`
  - Format + Lint: `jupyterblack`, `nbstripout`
  - Lint only: `flake8-nb`
- Bash:
  - Setup: `npm` and `conda`
  - Test: `bats` (bash testing: `bats-core`, `bats-assert`, `bats-support`)
  - Format + Lint: `shfmt`
  - Lint only: `shellcheck`
- Haskell:
  - Lint: `hlint`
- YAML:
  - Setup: `pip`
  - Lint: `yamllint`
- Prometheus and Alertmanager YAML:
  - Lint: `promtool check`, `amtool check-config`
- Markdown:
  - Setup: `npm`
  - Format + Lint: `markdownlint`

It is very easy to extend this list with another tool, just following the existing examples.

### Comparison with Pants, Bazel, Pre-commit and traditional Makefiles

Modern build tools like Pants or Bazel work similarly in terms of goals and targets, but they also add a caching layer
on previous results of running the goals. While they come equipped with heavy machinery to support enormous scale
projects, they also come with restrictions. In my opinion, Pants which is the most suitable modern build tool for
Python, for example, doesn't allow building environments with arbitrary package managers (e.g. conda, mamba),
does not work on Windows, prohibits inconsistent environments (which is good but sometimes simply impossible in
practice), does not yet support multiple environments. Bazel, requires maintaining the dependencies between Python files
twice, once as "imports" in the Python files (the normal thing to do) and twice in some specific `BUILD` files that
must be placed in each directory (by contrast Pants features autodiscovery). Maintaining the same dependencies in two
places is quite draining. Of course, these tools come with benefits like caching/incrementality and out-of-the-box
support for hermetic packaging (e.g. PEXes) but again neither supports arbitrary packers. In general, playing with some
new command line tools, or new programming languages / types of files (e.g. Jupyter Notebooks) is challenging with these
frameworks. The Pants community is very welcoming and supportive towards incorporating new tools, so it would be good to
give it a try first. However, if any of the mentioned shortcomings is a hard requirement, Make seems like a good and
robust alternative that withstood the test of time in so many settings.

Pre-commit and typical usages of Make work exceptionally well on small projects but they don't really scale well to
multi-projects monorepos. The build system proposed here, already incorporates `pre-commit` and is obviously compatible
with any existing Makefiles. This approach simply takes the idea of advanced target selection and ports it over to
classical techniques like pre-commit and Make.
