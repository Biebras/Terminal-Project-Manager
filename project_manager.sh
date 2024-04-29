#!/bin/bash

# Variables
script_dir=$(dirname "$0")
projects_dir=$("$script_dir/projects.txt")

# Cheack if file exists
if [ -e "projects.txt" ]
then
    echo "Project file exists"
else
    echo "Creating projects file"
    touch $projects_dir
fi

# Add command
if [[ $# -eq 1 && $1 == "add" ]]
then
    # Check if project exists
    if ! grep -q "$(pwd)" projects.txt
    then
        # Add current directory
        pwd >> $script
        echo "Added project"
    else
        echo "Project already exists"
    fi

    exit 0
fi

# Remove current directory
if [[ $# -eq 1 && $1 == "remove" ]]
then
    # Add current directory
    grep -v "$(pwd)" projects.txt > temp
    mv temp projects.txt
    echo "Removing project"

    exit 0
fi

# If no arguments then list the projects
if [[ $# -eq 0 ]]
then
    cat projects.txt | fzf
fi
