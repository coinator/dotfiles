#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/scripts/helpers.sh

dark_font="#3c3836"
color_font="#a89985"
white_font="#a89985"
blue="#62afef"
yellow="#fe8020"
red="#fb4934"
outer_bg="#a89985" #bright outer_bg
visual_grey="#504946"
comment_grey="#504946"


prefix_highlight_fg="$dark_font"
prefix_highlight_bg="$outer_bg"
prefix_highlight_copy_mode_attr="fg=$dark_font,bg=$outer_bg"
prefix_highlight_output_prefix="" 


colour_interpolation=(
        "\#{dark_font}"
        "\#{color_font}"
        "\#{blue}"
        "\#{yellow}"
        "\#{red}"
        "\#{white_font}"
        "\#{outer_bg}"
        "\#{visual_grey}"
        "\#{comment_grey}"
	"\#{prefix_highlight_f}"
	"\#{prefix_highlight_b}"
	"\#{prefix_highlight_copy_mode_att}"
	"\#{prefix_highlight_output_prefix}"
)

colour_commands=(
        "$dark_font"
        "$color_font"
        "$blue"
        "$yellow"
        "$red"
        "$white_font"
        "$outer_bg"
        "$visual_grey"
	"$comment_grey"
	"$prefix_highlight_f"
	"$prefix_highlight_b"
	"$prefix_highlight_copy_mode_att"
	"$prefix_highlight_output_prefix"
)


options() {
	set_tmux_option "status" "on"
	set_tmux_option "status-justify" "left"

	set_tmux_option "status-left-length" "100"
	set_tmux_option "status-right-length" "100"
	set_tmux_option "status-right-attr" "none"

	set_tmux_option "message-fg" "$white_font"
	set_tmux_option "message-bg" "$dark_font"

	set_tmux_option "message-command-fg" "$white_font"
	set_tmux_option "message-command-bg" "$dark_font"

	set_tmux_option "status-attr" "none"
	set_tmux_option "status-left-attr" "none"

	set_tmux_window_option "window-status-fg" "$dark_font"
	set_tmux_window_option "window-status-bg" "$dark_font"
	set_tmux_window_option "window-status-attr" "none"

	set_tmux_window_option "window-status-activity-bg" "$dark_font"
	set_tmux_window_option "window-status-activity-fg" "$dark_font"
	set_tmux_window_option "window-status-activity-attr" "none"

	set_tmux_window_option "window-status-separator" ""

	set_tmux_option "window-style" "fg=$comment_grey"
	set_tmux_option "window-active-style" "fg=$white_font"

	set_tmux_option "pane-border-fg" "$white_font"
	set_tmux_option "pane-border-bg" "$dark_font"
	set_tmux_option "pane-active-border-fg" "$outer_bg"
	set_tmux_option "pane-active-border-bg" "$dark_font"

	set_tmux_option "display-panes-active-colour" "$yellow"
	set_tmux_option "display-panes-colour" "$blue"

	set_tmux_option "status-bg" "$dark_font"
	set_tmux_option "status-fg" "$white_font"

	set_tmux_option "mode-style" "fg=$dark_font,bg=$yellow"

	set_tmux_option "message-style" "fg=$dark_font,bg=$yellow"

}


do_interpolation() {
	local all_interpolated="$1"
	for ((i=0; i<${#colour_commands[@]}; i++)); do
		all_interpolated=${all_interpolated//${colour_interpolation[$i]}/${colour_commands[$i]}}
	done
	echo "$all_interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	options
	update_tmux_option "status-right"
	update_tmux_option "status-left"
	update_tmux_option "window-status-format"
	update_tmux_option "window-status-current-format"
}
main
