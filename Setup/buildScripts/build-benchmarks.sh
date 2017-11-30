#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build Benchmarks
if [ "$1" = "style" ]
then
  exit 0
else
  if [ ! -d $BENCHMARKS_DIR ]
  then
    mkdir $BENCHMARKS_DIR
  fi
  checkout $ROOT_PATH/Benchmarks/AreWeFast "https://github.com/charig/are-we-fast-yet.git" "master" "benchmarks"
  checkout "$BENCHMARKS_DIR/Mate" "https://github.com/charig/som.git" "reflectiveCompiler" "Examples/Benchmarks/*;Smalltalk/*"
  $SCRIPT_PATH/makeBenchmarks.sh
fi
OK TruffleMATE Build Completed.
