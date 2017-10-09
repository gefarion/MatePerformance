#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
BUILDSCRIPTS=$SCRIPT_PATH/buildScripts
source $BUILDSCRIPTS/basicFunctions.inc
export ROOT_PATH=$SCRIPT_PATH
source $BUILDSCRIPTS/config.inc

update_git_repo $IMPLEMENTATIONS_PATH/TruffleMate/Standard
update_git_repo "$IMPLEMENTATIONS_PATH/TruffleMate/EnvironmentInObject"
update_git_repo $IMPLEMENTATIONS_PATH/RTruffleMate/Standard
update_git_repo "$IMPLEMENTATIONS_PATH/RTruffleMate/EnvironmentInObject"
update_git_repo $BENCHMARKS_DIR/Mate "som.git"