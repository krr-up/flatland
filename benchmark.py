import os
import sys
import subprocess
import concurrent.futures
import random
from tqdm import tqdm

def find_params_dirs():
    """Find all directories containing params.py files."""
    params_dirs = []
    for root, dirs, files in os.walk('asp'):
        if 'params.py' in files:
            params_dirs.append(root)
    return params_dirs

def find_pkl_files():
    """Find all .pkl files in envs/testing_instances and subdirectories."""
    pkl_files = []
    for root, dirs, files in os.walk('envs/testing_instances'):
        for file in files:
            if file.endswith('.pkl'):
                pkl_files.append(os.path.join(root, file))
    return pkl_files

def run_solve(params_file, pkl_file):
    """Run the solve command with the given parameters."""
    command = f"python solve.py {params_file} {pkl_file} --no-render --no-horizon"
    try:
        result = subprocess.run(command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=7200)  # 2 hour timeout
    except subprocess.TimeoutExpired:
        print(f"Command timed out: {command}")
        return -1  # Indicate that the command timed out
    return result.returncode

def main(parallel_processes):
    params_dirs = find_params_dirs()
    pkl_files = find_pkl_files()

    # Build combinations of params and .pkl files
    combinations = [(os.path.join(params, 'params.py'), pkl) for params in params_dirs for pkl in pkl_files]

    # Shuffle the combinations
    random.shuffle(combinations)

    # Use a progress bar with tqdm
    with tqdm(total=len(combinations), desc="Processing") as pbar:
        with concurrent.futures.ProcessPoolExecutor(max_workers=parallel_processes) as executor:
            future_to_combo = {executor.submit(run_solve, params_file, pkl_file): (params_file, pkl_file) for params_file, pkl_file in combinations}
            for future in concurrent.futures.as_completed(future_to_combo):
                params_file, pkl_file = future_to_combo[future]
                try:
                    return_code = future.result()
                    if return_code != 0:
                        print(f"Execution failed for: python solve.py \"{params_file}\" \"{pkl_file}\"")
                except Exception as e:
                    print(f"Error occurred for: python solve.py \"{params_file}\" \"{pkl_file}\": {e}")
                pbar.update(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python run_solve.py <number_of_parallel_processes>")
        sys.exit(1)

    try:
        parallel_processes = int(sys.argv[1])
        if parallel_processes <= 0:
            raise ValueError("The number of parallel processes must be a positive integer.")
    except ValueError as e:
        print(f"Invalid input: {e}")
        sys.exit(1)

    main(parallel_processes)
