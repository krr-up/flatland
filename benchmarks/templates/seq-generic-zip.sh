#!/bin/bash
# https://github.com/arminbiere/runlim

CAT="{run.root}/programs/gcat.sh"

cd "$(dirname $0)"

[[ -e .finished ]] || $CAT {run.files} {run.encodings} | "{run.root}/programs/runlim" \
	--space-limit={run.memout} \
	--output-file=runsolver.watcher \
	--real-time-limit={run.timeout} \
	"{run.root}/programs/{run.solver}" {run.args} > runsolver.solver

touch .finished
