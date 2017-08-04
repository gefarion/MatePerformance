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
  pushd libs/truffle
  if [ ! -d "java-jvmci-8" ]
  then
    find_and_link JAVA_JVMCI_DIR "java-jvmci-8" "/home/guido/Documents/Projects/TruffleMATE/libs/truffle/java-jvmci-8/"
  fi
  popd > /dev/null
  make clean; make
  OK TruffleMATE with Environments stored in Objects Build Completed.
  popd > /dev/null
fi

