#!/bin/bash

# Define the directory containing the .pkl files
pkl_folder="envs/pkl"

# Check if the folder exists
if [ ! -d "$pkl_folder" ]; then
  echo "Error: Folder '$pkl_folder' does not exist."
  exit 1
fi

# Array to store failed instances
failed_instances=()

# Loop through all .pkl files in the folder
for instance in "$pkl_folder"/*.pkl; do
  # Check if there are any .pkl files
  if [ ! -e "$instance" ]; then
    echo "No .pkl files found in '$pkl_folder'."
    exit 1
  fi

  # Run the solve.py command
  echo "Running 'python solve.py $instance'"
  python solve.py "$instance" > /dev/null 2>&1

  
  # Check if the command was successful
  if [ $? -ne 0 ]; then
    echo "Failed to process $instance"
    failed_instances+=("$instance")
  fi
done

# Output the failed instances, if any
if [ ${#failed_instances[@]} -eq 0 ]; then
  echo "All instances processed successfully."
else
  echo "The following instances failed:"
  for failed_instance in "${failed_instances[@]}"; do
    echo "$failed_instance"
  done
fi
