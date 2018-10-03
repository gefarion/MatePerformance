#!/bin/bash
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

BASE_DIR="$SCRIPT_PATH/.."
source $BASE_DIR/config.inc

if [ "$1" == "--envInObject" ]
then
    exec $TRUFFLE_MATE_DIR/EnvironmentInObject/som ${@:2}
else
    exec $TRUFFLE_MATE_DIR/$TRUFFLEMATE_REPO_MO_NAME/som "$@"
fi
