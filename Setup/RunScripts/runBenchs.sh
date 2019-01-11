#!/bin/bash
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

BUILDSCRIPTS="$SCRIPT_PATH/../BuildScripts"
source "$BUILDSCRIPTS/basicFunctions.inc"

pushd $ROOT_PATH
exec sudo env "PATH=$PATH:/home/guido/.local/bin/" rebench -d mate.conf "$@"
mv *.data $DATA_DIR/ 
popd
