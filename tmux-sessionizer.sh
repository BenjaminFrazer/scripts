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
    
    # Find git repos and .workspace-marked directories, combine with specific folders
    selected=$(
        (find "${search_paths[@]}" -mindepth 2 -maxdepth 2 -name ".git" -exec dirname {} \; 2>/dev/null
         find "${search_paths[@]}" -maxdepth 5 -name ".workspace" -exec dirname {} \; 2>/dev/null
         printf '%s\n' "${specific_folders[@]}" 2>/dev/null) | sort -u | fzf
    )
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Build session name from git repo context to avoid collisions
git_root=$(git -C "$selected" rev-parse --show-toplevel 2>/dev/null)
if [[ -n "$git_root" ]]; then
    repo_parent=$(basename "$(dirname "$git_root")")
    repo_name=$(basename "$git_root")
    rel_path="${selected#"$git_root"}"
    rel_path="${rel_path#/}"
    if [[ -n "$rel_path" ]]; then
        selected_name="${repo_parent}/${repo_name}/${rel_path}"
    else
        selected_name="${repo_parent}/${repo_name}"
    fi
else
    selected_name=$(basename "$selected")
fi
selected_name=$(echo "$selected_name" | tr '.:' '_')
tmux_running=$(pgrep tmux)

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
    if [[ -f "$selected/.workspace" ]]; then
        session_name=$selected_name session_dir=$selected source "$selected/.workspace"
    fi
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi
