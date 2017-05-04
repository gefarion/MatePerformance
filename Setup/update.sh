#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
BUILDSCRIPTS=$SCRIPT_PATH/buildScripts
source $BUILDSCRIPTS/basicFunctions.inc

export ROOT_PATH=$SCRIPT_PATH

source $BUILDSCRIPTS/config.inc

updateGitRepo $IMPLEMENTATIONS_PATH/TruffleMate/Standard
updateGitRepo "$IMPLEMENTATIONS_PATH/TruffleMate/EnvironmentInObject"
updateGitRepo $BENCHMARKS_DIR/Mate "som.git"