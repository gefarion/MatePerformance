#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build MATE Implementations
NAME="$1"
TRUFFLE_BRANCH="$2"
PYPY_BRANCH="$3"
if [ ! -d $ROOT_PATH/Implementations/TruffleMate ]
then
  mkdir $ROOT_PATH/Implementations/TruffleMate
fi
checkout $ROOT_PATH/Implementations/TruffleMate/$NAME "https://github.com/charig/TruffleMATE.git" $TRUFFLE_BRANCH
pushd $ROOT_PATH/Implementations/TruffleMate/$NAME
INFO "Compiling TruffleMATE" 
make clean; make
OK TruffleMATE Build Completed.
popd > /dev/null

if [ ! -d $ROOT_PATH/Implementations/RTruffleMate ]
then
  mkdir $ROOT_PATH/Implementations/RTruffleMate
fi
checkout $ROOT_PATH/Implementations/RTruffleMate/$NAME "https://github.com/charig/RTruffleMATE.git" $PYPY_BRANCH
pushd $ROOT_PATH/Implementations/RTruffleMate/$NAME
if [ ! -d "pypy" ]
then
  find_and_link PYPY_DIR "pypy" "/home/guido/pypy" 
fi
INFO "Compiling RTruffleMATE in JIT mode (may take some time...)"
make clean; JIT=True make
OK RTruffleMATE Build Completed.
popd > /dev/null
OK MATE Build Completed.
