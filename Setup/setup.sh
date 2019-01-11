#!/bin/bash
set -e # make script fail on first error

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

source "$SCRIPT_PATH/BuildScripts/basicFunctions.inc"

## Check for requirements
check_for_tools git ant make mv uname cc c++
check_for_node  "non-fatal"
check_for_pypy  "non-fatal"

## Install the different implementations
$BUILDSCRIPTS_DIR/build-mate.sh "$MATE_IMPL_INSHAPE_NAME" "master" "metaobjectInShape"
#$BUILDSCRIPTS_DIR/build-mate.sh "$MATE_IMPL_INOBJECT_NAME" "environmentInObject" "metaobjectInObject"
$BUILDSCRIPTS_DIR/build-pharo.sh
$BUILDSCRIPTS_DIR/build-benchmarks.sh
