#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Building Benchmarks
if [ "$1" = "style" ]
then
  exit 0
else
  INFO Building Java Benchmarks
  pushd $BENCHMARKS_DIR\Java
  ant jar
  popd > /dev/null
  OK Java Benchmarks Build Completed.  
fi
OK TruffleMATE Build Completed.
