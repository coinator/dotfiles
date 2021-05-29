#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

default_start_pomodoro="a"
start_pomodoro="@pomodoro_start"
default_cancel_pomodoro="A"
cancel_pomodoro="@pomodoro_cancel"

pomodoro_st="#($CURRENT_DIR/scripts/pomodoro.sh)"
pomodoro_st_interpolation_string="\#{pomodoro_st}"

source $CURRENT_DIR/scripts/helpers.sh

set_start_binding() {
	local key_bindings=$(get_tmux_option "$start_pomodoro" "$default_start_pomodoro")
	local key
	for key in $key_bindings; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/pomodoro.sh start"
	done
}

set_cancel_binding() {
	local key_bindings=$(get_tmux_option "$cancel_pomodoro" "$default_cancel_pomodoro")
	local key
	for key in $key_bindings; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/pomodoro.sh cancel"
	done
}

do_interpolation() {
	local string="$1"
	local interpolated="${string/$pomodoro_st_interpolation_string/$pomodoro_st}"
	echo "$interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
    set_start_binding
    set_cancel_binding
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}
main
