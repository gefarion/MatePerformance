#!/bin/bash
SCRIPT_PATH=`dirname $0`

ALL=false

if [ "$#" -eq 0 ]
then
    ALL=true
fi

if [[ "$ALL" = true || "$@" == "dynMetrics"  ]]
then
    ./runScripts/runDynMetrics.sh
fi

if [[ "$ALL" = true || "$@" == "AreWeFast" || "$@" == "Inherent" || "$@" == "IndividualActivations" ]]
then
    ./runScripts/runBenchs.sh $@
fi

