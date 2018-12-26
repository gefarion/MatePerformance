#!/bin/bash
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

ALL=false

if [ "$#" -eq 0 ]
then
    ALL=true
fi

if [[ "$@" == "dynMetrics"  ]]
then
    "$SCRIPT_PATH/RunScripts/runDynMetrics.sh"
fi

if [[ "$ALL" = true || "$@" == "AreWeFast" || "$@" == "Inherent" || "$@" == "IndividualActivations" || "$@" == "Readonly" || "$@" == "Tracing" || "$@" == "ReflectiveCompilation" ]]
then
    "$SCRIPT_PATH/RunScripts/runBenchs.sh" $@
fi

