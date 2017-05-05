#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build MATE Implementations
if [ "$1" = "style" ]
then
  exit 0
else
  checkout $ROOT_PATH/Implementations/TruffleMate/Standard "https://github.com/charig/TruffleMATE.git" "reflectiveCompiler"
  pushd $ROOT_PATH/Implementations/TruffleMate/Standard
  INFO Compiling TruffleMATE
  make clean; make
  OK TruffleMATE Build Completed.
  popd > /dev/null
  checkout $ROOT_PATH/Implementations/RTruffleMate/ "https://github.com/charig/RTruffleMATE.git" "wrapping-nodes"
  pushd $ROOT_PATH/Implementations/RTruffleMate/
  if [ ! -d "pypy" ]
  then
    find_and_link PYPY_DIR "pypy"
  fi
  INFO "Compiling RTruffleMATE in JIT mode (may take some time...)"
  make clean; JIT=True make
  OK RTruffleMATE Build Completed.
  popd > /dev/null
fi
OK MATE Build Completed.
