#!/bin/bash
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

if [ "$1" = "style" ]
then
  exit 0
fi

BUILDSCRIPTS="$SCRIPT_PATH"
source "$BUILDSCRIPTS/basicFunctions.inc"

if [ ! -x "$PHARO_DIR/pharo" ]; then
  if [ ! -d "$PHARO_DIR" ]; then
    mkdir -p "$PHARO_DIR"
  fi
  INFO Get Pharo VM
  pushd "$PHARO_DIR"
  get_web_getter
  $GET get.pharo.org/vm60 || $GET get.pharo.org/vm60
  bash vm60
  
  INFO Get Pharo Image
  $GET get.pharo.org/stable || $GET get.pharo.org/stable
  bash stable
  popd
fi
