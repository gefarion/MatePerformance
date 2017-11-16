#!/bin/bash
SCRIPT_PATH=`dirname $0`

ALL=false

if [ "$#" -eq 0 ]
then
    ALL=true
fi

if [[ "$@" == "dynMetrics"  ]]
then
    ./runScripts/runDynMetrics.sh
fi

if [[ "$ALL" = true || "$@" == "AreWeFast" || "$@" == "Inherent" || "$@" == "IndividualActivations" || "$@" == "Readonly" || "$@" == "Tracing" || "$@" == "ReflectiveCompilation" ]]
then
    ./runScripts/runBenchs.sh $@
fi

