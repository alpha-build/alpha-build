DEFAULT_PYTHON_ENV='3rdparty/py-env'

# Config files
MYPY_CONFIG=build-support/python/tools-config/mypy.ini
PYLINT_CONFIG=build-support/python/tools-config/pylintrc
FLAKE8_CONFIG=build-support/python/tools-config/.flake8
ISORT_CONFIG=build-support/python/tools-config/pyproject.toml
BLACK_CONFIG=build-support/python/tools-config/pyproject.toml
BANDIT_CONFIG=build-support/python/tools-config/.bandit.yml
PYTEST_CONFIG=build-support/python/tools-config/pyproject.toml
RUFF_CONFIG=build-support/python/tools-config/pyproject.toml

# Tools config
#DEFAULT_PYTEST_MARKS=""
#DEFAULT_PYTEST_CASES=""
DEFAULT_THIRD_PARTY_DEPS_FILE=$(DEFAULT_PYTHON_ENV)/requirements.txt
DEFAULT_FIRST_PARTY_DEPS_FILE=build-support/python/packaging/first-party-libs.txt

# Flags
DOCFORMATTER_FLAGS=--wrap-summaries=120 --wrap-descriptions=120
ISORT_FLAGS=--settings-path $(ISORT_CONFIG)
AUTOFLAKE_FLAGS=--remove-all-unused-imports
BLACK_FLAGS=-S --config $(BLACK_CONFIG)
FLAKE8_FLAGS=--config=$(FLAKE8_CONFIG)
BANDIT_FLAGS=--configfile $(BANDIT_CONFIG)
PYLINT_FLAGS=--rcfile=$(PYLINT_CONFIG)
PYTEST_FLAGS=-c $(PYTEST_CONFIG)
MYPY_FLAGS=--config-file $(MYPY_CONFIG)
PIPREQS_FLAGS=--print
RUFF_FLAGS=--config $(RUFF_CONFIG)
