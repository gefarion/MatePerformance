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
  if [ ! -e "$PWD/graal" ]
  then
    find_and_link GRAAL_OFICIAL "graal" "~/graal"
  fi
  if [ ! -e "$PWD/java-jvmci-8" ]
  then
    find_and_link JAVA_JVMCI_DIR "java-jvmci-8" "~/Documents/Projects/TruffleMATE/libs/truffle/java-jvmci-8/"
  fi
  INFO "Compiling TruffleMATE" 
  make clean; make
  OK TruffleMATE Build Completed.
  popd > /dev/null
fi
OK MATE Build Completed.
