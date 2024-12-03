#!/bin/bash

# Define the directories to clean
directories=("envs/pkl" "envs/lp" "envs/png" "output")

# Loop through each directory and delete files
for dir in "${directories[@]}"; do
  if [ -d "$dir" ]; then
    echo "Cleaning files in $dir"
    rm -rf "$dir"/*
  else
    echo "Warning: Directory $dir does not exist."
  fi
done

echo "Cleanup completed."