#!/bin/bash

SCRIPT_PATH=`cd $(dirname "$0") && pwd`
if [ ! -d $SCRIPT_PATH ]; then
  echo "Could not determine absolute dir of $0"
  echo "Maybe accessed with symlink"
fi

if [[ ! -d $1 ]]; then
    echo "First parameter must specify a valid directory to copy all the data"
    exit 1
fi

PAPER_PATH=$1

cp ${SCRIPT_PATH}/images/*.pdf "$PAPER_PATH/images/"
cp experiments.tex "$PAPER_PATH/sections/experiments.tex"

IMAGES_PATH="$SCRIPT_PATH/images"
PAPER_IMAGES_PATH="images"

sed -i -e "s+$IMAGES_PATH+$PAPER_IMAGES_PATH+g"  "$PAPER_PATH/sections/experiments.tex"
