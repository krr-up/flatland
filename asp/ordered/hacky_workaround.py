import subprocess
import sys
import os
import json

# Output file path
output_file_path = "asp/ordered/tmp.lp"

# Ensure correct usage
if len(sys.argv) != 2:
    print("Usage: python script.py <file>")
    sys.exit(1)

# Get the input file from the command-line argument
input_file = sys.argv[1]

def run_command(command, input_text=None):
    """
    Runs a command and returns its stdout. Ignores non-zero exit codes but checks for "UNSATISFIABLE" in JSON output.
    """
    try:
        result = subprocess.run(
            command,
            input=input_text,  # Pass input for piping (e.g., formatted atoms)
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        # Try to parse the output as JSON
        try:
            result_json = json.loads(result.stdout)
        except json.JSONDecodeError:
            print(f"Error: Failed to parse JSON output from: {' '.join(command)}", file=sys.stderr)
            sys.exit(1)
        
        # Check if the result is UNSATISFIABLE
        if result_json.get("Result") == "UNSATISFIABLE":
            print(f"Error: Command {' '.join(command)} returned UNSATISFIABLE.", file=sys.stderr)
            sys.exit(1)
        
        return result_json
    except Exception as e:
        print(f"Error running command {' '.join(command)}: {e}", file=sys.stderr)
        sys.exit(1)

def print_summary(data, label):
    """
    Prints the summary fields (Models, Calls, Time, CPU Time) for the given JSON data.
    """
    models = data.get("Models", {})
    calls = data.get("Calls", 0)
    time = data.get("Time", {})
    
    print(f"{label} Summary:")
    print(f"Models       : {models.get('Number', 0)}{'+' if models.get('More') == 'yes' else ''}")
    print(f"Calls        : {calls}")
    print(f"Time         : {time.get('Total', 0):.3f}s (Solving: {time.get('Solve', 0):.2f}s 1st Model: {time.get('Model', 0):.2f}s Unsat: {time.get('Unsat', 0):.2f}s)")
    print(f"CPU Time     : {time.get('CPU', 0):.3f}s\n")

# Step 1: Run clingo-dl
clingo_dl_command = [
    "clingo-dl",
    "asp/ordered/0_input.lp",
    "asp/ordered/1_path.lp",
    "asp/ordered/2_conflicts.lp",
    input_file,
    "--outf=2"
]
clingo_dl_json = run_command(clingo_dl_command)

# Print clingo-dl summary
print_summary(clingo_dl_json, "clingo-dl")

# Extract all atoms and format them into point-separated predicates
all_atoms = []
for call in clingo_dl_json.get("Call", []):
    for witness in call.get("Witnesses", []):
        all_atoms.extend(witness.get("Value", []))

formatted_atoms = ".\n".join(all_atoms) + ".\n"

# Step 2: Pipe the formatted atoms into clingo
clingo_command = ["clingo", "-", "asp/ordered/3_output.lp", "--outf=2"]
clingo_json = run_command(clingo_command, input_text=formatted_atoms)

# Print clingo summary
print_summary(clingo_json, "clingo")

# Extract action atoms from the clingo output
actions = []
for call in clingo_json.get("Call", []):
    for witness in call.get("Witnesses", []):
        for value in witness.get("Value", []):
            if value.startswith("action("):  # Filter for "action" atoms
                actions.append(value)

# Step 3: Write the actions to tmp.lp
os.makedirs(os.path.dirname(output_file_path), exist_ok=True)  # Ensure the directory exists
with open(output_file_path, "w") as output_file:
    output_file.write(".\n".join(actions) + ".\n")  # Add '.' at the end of each predicate

print(f"Written {len(actions)} actions to {output_file_path}")
