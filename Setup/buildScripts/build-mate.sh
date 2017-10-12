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
  if [ ! -d $ROOT_PATH/Implementations/TruffleMate ]
  then
    mkdir $ROOT_PATH/Implementations/TruffleMate
  fi
  checkout $ROOT_PATH/Implementations/TruffleMate/Standard "https://github.com/charig/TruffleMATE.git" "reflectiveCompiler"
  pushd $ROOT_PATH/Implementations/TruffleMate/Standard
  if [ ! -d "graal" ]
  then
    find_and_link GRAAL_OFICIAL graal "/home/guido/graal"
  fi
  if [ ! -d "java-jvmci-8" ]
  then
    find_and_link JAVA_JVMCI_DIR "java-jvmci-8" "/home/guido/Documents/Projects/TruffleMATE/libs/truffle/java-jvmci-8/"
  fi
  INFO "Compiling TruffleMATE" 
  make clean; make
  OK TruffleMATE Build Completed.
  popd > /dev/null
  if [ ! -d $ROOT_PATH/Implementations/RTruffleMate ]
  then
    mkdir $ROOT_PATH/Implementations/RTruffleMate
  fi
  checkout $ROOT_PATH/Implementations/RTruffleMate/Standard "https://github.com/charig/RTruffleMATE.git" "meta-mop-in-shape"
  pushd $ROOT_PATH/Implementations/RTruffleMate/Standard
  if [ ! -d "pypy" ]
  then
    find_and_link PYPY_DIR "pypy" "/home/guido/pypy" 
  fi
  INFO "Compiling RTruffleMATE in JIT mode (may take some time...)"
  make clean; JIT=True make
  OK RTruffleMATE Build Completed.
  popd > /dev/null
fi
OK MATE Build Completed.
