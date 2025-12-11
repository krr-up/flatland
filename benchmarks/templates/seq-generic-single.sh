#!/bin/bash
# https://github.com/arminbiere/runlim

CAT="{run.root}/programs/gcat.sh"

cd "$(dirname $0)"

runner=( "{run.root}/programs/runlim" \
  --single \
  --space-limit={run.memout} \
  --output-file=runsolver.watcher \
  --real-time-limit={run.timeout} \
  "{run.root}/programs/{run.solver}" {run.args})

input=( {run.files} {run.encodings} )

if [[ ! -e .finished ]]; then
  {{
    if file -b --mime-type -L  "${{input[@]}}" | grep -qv "text/"; then
      "$CAT" "${{input[@]}}" | "${{runner[@]}}"
    else
      "${{runner[@]}}" "${{input[@]}}"
    fi
  }} > runsolver.solver
fi

touch .finished
