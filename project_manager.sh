#!/bin/bash

# Variables
script_dir=$(dirname "$0")
projects_dir="$script_dir/projects.txt"

# Cheack if file exists
if [ ! -e $projects_dir ]; then
    echo "Init Project Manager!"
    touch $projects_dir
fi

# Add command
if [[ $# -eq 1 && $1 == "add" ]]
then
    # Check if project exists
    if ! grep -q "$(pwd)" $projects_dir
    then
        # Add current directory
        pwd >> $projects_dir
        echo "Project Added!"
    else
        echo "Can't add project already exists"
    fi

    exit 0
fi

# Remove current directory
if [[ $# -eq 1 && $1 == "remove" ]]
then
    # Add current directory
    grep -v "$(pwd)" $projects_dir > temp
    mv temp $projects_dir
    echo "Project Removed!"

    exit 0
fi

# If no arguments then list the projects
if [[ $# -eq 0 ]]
then
    selected=`cat $projects_dir | fzf`
    selected_name=$(basename "$selected" | tr . _)
   
    if [[ $selected == "q" || $selected == "quit" ]]; then
        exit 0
    fi

    if [ -z $selected_name ]; then
        exit 0
    fi

    # Check if tmux is running
    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]
    then
        # Check if session with name exists
        if ! tmux has-session -t=$selected_name 2> /dev/null; then
            echo "Session not found, creating a new one"
            tmux new-session -s $selected_name -c $selected
        else
            echo "Session found, attaching"
            tmux attach -t $selected_name
        fi

        exit 0
    fi

    # Check if session with name exists
    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        echo "Session was not found, creating a session"
        tmux new-session -ds $selected_name -c $selected
    fi

    tmux switch-client -t $selected_name
fi
