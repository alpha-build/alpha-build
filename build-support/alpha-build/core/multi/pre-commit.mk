.PHONY: pre-commit-run
pre-commit-run:
	$(eval targets := $(onprecommit))
	$(python) -m pre_commit run $(hook) $(PRE_COMMIT_RUN_FLAGS) $(targets)
