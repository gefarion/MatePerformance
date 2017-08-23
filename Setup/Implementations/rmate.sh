#!/bin/bash
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/../buildScripts/config.inc
ARGS=1
if [ "$1" == "--jit" ]
then
    BIN=RTruffleSOM-jit
    ARGS=$((ARGS + 1))
else
    BIN=RTruffleSOM-no-jit
fi
if [[ "$1" == "--envInObject" || "$2" == "--envInObject" ]]
then
    DIR=$SCRIPT_PATH/RTruffleMate/EnvironmentInObject
    ARGS=$((ARGS + 1))
else
    DIR=$SCRIPT_PATH/RTruffleMate/Standard
fi

exec $DIR/$BIN ${@:$ARGS}
