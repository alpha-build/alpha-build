.PHONY: pre-commit-run
pre-commit-run:
	$(eval targets := $(onprecommit))
	$(python) -m pre_commit run $(PRE_COMMIT_RUN_FLAGS) $(targets) $(hook)
