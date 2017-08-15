#!/bin/bash
if [ "$1" = "style" ]
then
  exit 0
fi

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

if [ ! -x "$IMPLEMENTATIONS_PATH/pharo/pharo" ]; then
  if [ ! -d "$IMPLEMENTATIONS_PATH/pharo" ]; then
    mkdir $IMPLEMENTATIONS_PATH/pharo
  fi
  INFO Get Pharo VM
  pushd $IMPLEMENTATIONS_PATH/pharo
  get_web_getter
  $GET get.pharo.org/vm50 || $GET get.pharo.org/vm50
  bash vm50
  
  INFO Get Pharo Image
  $GET get.pharo.org/stable || $GET get.pharo.org/stable
  bash stable
  popd
fi
