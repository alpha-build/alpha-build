package-py: shiv

shiv:
	$(eval targets := .)
	find $(on) -type f -name "shiv-package.sh" | sort | xargs bash
