#!/usr/bin/env bash

# "nvim session strategy"
#
# Same as vim strategy, see file 'vim_session.sh'

ORIGINAL_COMMAND="$1"
DIRECTORY="$2"

nvim_session_file_exists() {
	[ -e "${DIRECTORY}/.resurrect" ]
}

original_command_contains_session_flag() {
	[[ "$ORIGINAL_COMMAND" =~ "-c Resurrect" ]]
}

main() {
	if nvim_session_file_exists; then
		echo "nvim -c Resurrect"
	elif original_command_contains_session_flag; then
		echo "nvim"
	else
		echo "$ORIGINAL_COMMAND"
	fi
}
main
