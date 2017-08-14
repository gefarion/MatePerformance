#!/bin/bash
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/../buildScripts/config.inc
export GRAAL_HOME=$GRAAL_HOME
#export GRAAL_FLAGS=$GRAAL_HOSTED_FLAGS
if [ "$1" == "--envInObject" ]
then
    exec $SCRIPT_PATH/TruffleMate/EnvironmentInObject/som ${@:2}
else
    exec $SCRIPT_PATH/TruffleMate/Standard/som "$@"
fi
