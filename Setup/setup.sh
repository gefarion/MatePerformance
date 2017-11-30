#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
BUILDSCRIPTS=$SCRIPT_PATH/buildScripts
source $BUILDSCRIPTS/basicFunctions.inc
source $BUILDSCRIPTS/config.inc

export ROOT_PATH=$SCRIPT_PATH

echo $GRAAL_OFICIAL

## Check for requirements
check_for_tools git ant make mv uname cc c++
check_for_node    "non-fatal"
check_for_graalvm $GRAAL_OFICIAL
check_for_pypy  "non-fatal"

$BUILDSCRIPTS/build-mate.sh
$BUILDSCRIPTS/build-pharo.sh
$BUILDSCRIPTS/build-benchmarks.sh

OK done.
