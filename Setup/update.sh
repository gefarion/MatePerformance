#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

BASE_DIR="$SCRIPT_PATH"

source "$BASE_DIR/config.inc"
source "$BUILDSCRIPTS_DIR/basicFunctions.inc"

update_git_repo $TRUFFLE_MATE_DIR/$TRUFFLEMATE_REPO_MO_NAME
if [ ! -z "$JAVA_HOME_TRUFFLE" ]
then
  export JAVA_HOME="$JAVA_HOME_TRUFFLE"
fi
compile_with_ant $TRUFFLE_MATE_DIR/$TRUFFLEMATE_REPO_MO_NAME
export JAVA_HOME=""
#update_git_repo "$IMPLEMENTATIONS_PATH/TruffleMate/EnvironmentInObject"
update_git_repo $RTRUFFLE_MATE_DIR/$TRUFFLEMATE_REPO_MO_NAME
export JIT=1
compile_with_makefile $TRUFFLE_MATE_DIR/$TRUFFLEMATE_REPO_MO_NAME
export JIT=0
#update_git_repo "$IMPLEMENTATIONS_PATH/RTruffleMate/EnvironmentInObject"
update_git_repo $BENCHMARKS_DIR/Mate "som.git"