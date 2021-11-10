#!/usr/bin/env bash

assert_command_exists() {
	local COMMAND
	COMMAND="$1"
	if command -v "$COMMAND"; then
		echo "Found $COMMAND at $(command -v "$COMMAND")"
	else
		echo "$COMMAND does not exist"
		exit 1
	fi
}
