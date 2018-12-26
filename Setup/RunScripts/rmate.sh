#!/bin/bash
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

BUILDSCRIPTS="$SCRIPT_PATH/../BuildScripts"
source "$BUILDSCRIPTS/basicFunctions.inc"

ARGS=1
if [ "$1" == "--jit" ]
then
    BIN=RTruffleMate-jit
    ARGS=$((ARGS + 1))
else
    BIN=RTruffleMate-no-jit
fi
if [[ "$1" == "--envInObject" || "$2" == "--envInObject" ]]
then
    DIR=$RTRUFFLE_MATE_DIR/$MATE_IMPL_INOBJECT_NAME
    ARGS=$((ARGS + 1))
else
    DIR=$RTRUFFLE_MATE_DIR/$MATE_IMPL_INSHAPE_NAME
fi

exec $DIR/$BIN ${@:$ARGS}
