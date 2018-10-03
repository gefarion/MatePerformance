#!/bin/bash
set -e # make script fail on first error

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

BASE_DIR="$SCRIPT_PATH/.."
source "$BASE_DIR/config.inc"
source "$BUILDSCRIPTS_DIR/basicFunctions.inc"

INFO Build MATE Implementations
IMPLEMENTATION_NAME="$1"
TRUFFLE_BRANCH="$2"
PYPY_BRANCH="$3"

if [ ! -d "$TRUFFLE_MATE_DIR" ]
then
  mkdir "$TRUFFLE_MATE_DIR"
fi

checkout "$TRUFFLE_MATE_DIR/$IMPLEMENTATION_NAME" "$TRUFFLEMATE_REPO_URL" "$TRUFFLE_BRANCH"
pushd "$TRUFFLE_MATE_DIR/$IMPLEMENTATION_NAME"
INFO "Compiling TruffleMATE" 
if [ ! -z "$JAVA_HOME_TRUFFLE" ]
then
  export JAVA_HOME="$JAVA_HOME_TRUFFLE"
fi
compile_with_ant $TRUFFLE_MATE_DIR/$IMPLEMENTATION_NAME
OK TruffleMATE Build Completed.
popd > /dev/null

if [ ! -d "$RTRUFFLE_MATE_DIR" ]
then
  mkdir "$RTRUFFLE_MATE_DIR"
fi
checkout "$RTRUFFLE_MATE_DIR/$IMPLEMENTATION_NAME" "$RTRUFFLEMATE_REPO_URL" "$PYPY_BRANCH"
pushd "$RTRUFFLE_MATE_DIR/$IMPLEMENTATION_NAME"
if [ ! -d "pypy" ]
then
  find_and_link PYPY_DIR "pypy" "/home/guido/pypy" 
fi
INFO "Compiling RTruffleMATE in JIT mode (may take some time...)"
export JIT=1
compile_with_makefile $RTRUFFLE_MATE_DIR/$IMPLEMENTATION_NAME
export JIT=0
OK RTruffleMATE Build Completed.
popd > /dev/null
OK MATE Build Completed.
