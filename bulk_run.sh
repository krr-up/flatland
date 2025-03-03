#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_params.py> <path_to_pkl_folder>"
    exit 1
fi

# Assign the arguments to variables
params_file="$1"
pkl_folder="$2"

# Normalize the folder path by removing trailing slashes
pkl_folder="${pkl_folder%/}"

# Check if the params file exists
if [ ! -f "$params_file" ]; then
  echo "Error: File '$params_file' does not exist."
  exit 1
fi

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
  echo "Running 'python solve.py $params_file $instance --no-horizon'"
  python solve.py "$params_file" "$instance" --no-render --no-horizon > /dev/null 2>&1

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
