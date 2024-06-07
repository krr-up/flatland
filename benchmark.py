import os
import subprocess
import re

# file directories
workin_dir = os.path.abspath("/home/murphy2/flatland")
large = os.path.abspath("/home/murphy2/flatland/benchmarking/envs/lp/large")
medium = os.path.abspath("/home/murphy2/flatland/benchmarking/envs/lp/medium")
small = os.path.abspath("/home/murphy2/flatland/benchmarking/envs/lp/small")

# list of file names
files = sum([["benchmarking/envs/lp/small/" + file for file in os.listdir(small)], ["benchmarking/envs/lp/medium/" + file for file in os.listdir(medium)], ["benchmarking/envs/lp/large/" + file for file in os.listdir(large)]], [])

# file to log output
output = []

for file in files[0:2]:
    # process for action-based and graph-based encodings
    action_proc = subprocess.run(["clingo", "encodings/action_based/encoding.lp", "encodings/action_based/actions.lp", "encodings/action_based/transitions.lp", file], stdout=subprocess.PIPE)
    graph_proc = subprocess.run(["clingo", "encodings/graph_based/traverse.lp", "encodings/graph_based/actions.lp", "encodings/graph_based/connections.lp", file], stdout=subprocess.PIPE)

    # capture result outputs
    action_groups = re.findall("Time.*?\:\s(\d+\.\d+)s\s\(Solving\:\s(\d+\.\d+)s", action_proc.stdout.decode("utf-8"))
    graph_groups = re.findall("Time.*?\:\s(\d+\.\d+)s\s\(Solving\:\s(\d+\.\d+)s", graph_proc.stdout.decode("utf-8"))

    # append to output file
    output.append((file, action_groups, graph_groups))

with open('output.txt', 'w') as f:
    for line in output:
        f.write(f"{line}\n")