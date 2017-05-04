#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build TruffleMATE
if [ "$1" = "style" ]
then
  exit 0
else
  checkout $ROOT_PATH/Implementations/TruffleMate/Standard "https://github.com/charig/TruffleMATE.git" "reflectiveCompiler"
  pushd $ROOT_PATH/Implementations/TruffleMate/Standard
  make clean; make
  popd > /dev/null
fi
OK TruffleMATE Build Completed.
