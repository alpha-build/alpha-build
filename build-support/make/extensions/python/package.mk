package-py: shiv

shiv:
	$(eval on := .)
	find $(on) -type f -name "shiv-package.sh" | sort | xargs bash
