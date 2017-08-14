#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build Crystal Benchmarks
pushd $BENCHMARKS_DIR/AreWeFast/benchmarks/Crystal
if [ "$1" = "style" ]
then
  exit 0
else
  ./build.sh
fi