#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Building Benchmarks
if [ "$1" = "style" ]
then
  exit 
else
  buildBench Java $BENCHMARKS_DIR/AreWeFast/benchmarks/Java "ant jar"
  buildBench Crystal $BENCHMARKS_DIR/AreWeFast/benchmarks/Crystal "build.sh"
  if [ -e "$SCRIPT_PATH/../node_modules/jshint/bin/jshint" ]
  then
    CMD="$SCRIPT_PATH/../node_modules/jshint/bin/jshint *.js"
  else
    CMD="jshint *.js"
  fi
  buildBench JS $BENCHMARKS_DIR/AreWeFast/benchmarks/JavaScript $CMD
fi
OK Benchmarks Build Completed.
