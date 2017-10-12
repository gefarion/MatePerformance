#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build TruffleMATE with Environments stored in Objects
if [ "$1" = "style" ]
then
  exit 0
else
  checkout $ROOT_PATH/Implementations/TruffleMate/EnvironmentInObject "https://github.com/charig/TruffleMATE.git" "EnvironmentInObject"
  pushd $ROOT_PATH/Implementations/TruffleMate/EnvironmentInObject
  if [ ! -d "graal" ]
  then
    find_and_link GRAAL_OFICIAL graal "/home/guido/graal"
  fi
  if [ ! -d "java-jvmci-8" ]
  then
    find_and_link JAVA_JVMCI_DIR "java-jvmci-8" "/home/guido/Documents/Projects/TruffleMATE/libs/truffle/java-jvmci-8/"
  fi
  make clean; make
  OK TruffleMATE with Environments stored in Objects Build Completed.
  popd > /dev/null
  checkout $ROOT_PATH/Implementations/RTruffleMate/EnvironmentInObject "https://github.com/charig/RTruffleMATE.git" "meta-mop-in-obj"
  pushd $ROOT_PATH/Implementations/RTruffleMate/EnvironmentInObject
  if [ ! -d "pypy" ]
  then
    find_and_link PYPY_DIR "pypy" "/home/guido/Documents/Projects/pypy"
  fi
  INFO "Compiling RTruffleMATE in JIT mode (may take some time...)"
  make clean; JIT=True make
  OK RTruffleMATE Build Completed.
  popd > /dev/null
fi

