#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Define search paths - add more directories here as needed
    search_paths=(
        "$HOME/repos"
        # Add more paths here, e.g.:
        # "$HOME/projects"
        # "$HOME/work"
    )
    
    # Define specific folders to include without searching
    specific_folders=(
        # Add specific folders here, e.g.:
        "$HOME/dotfiles/"
        "$HOME/dotfiles/.config/nvim"
    )
    
    # Find git repos in search paths and combine with specific folders
    selected=$(
        (find "${search_paths[@]}" -mindepth 2 -maxdepth 2 -type d -name ".git" -exec dirname {} \; 2>/dev/null
         printf '%s\n' "${specific_folders[@]}" 2>/dev/null) | sort -u | fzf
    )
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi
