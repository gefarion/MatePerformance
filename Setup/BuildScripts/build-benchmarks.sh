#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

BUILDSCRIPTS="$SCRIPT_PATH"
source "$BUILDSCRIPTS/basicFunctions.inc"

INFO Build Benchmarks
if [ ! -d $BENCHMARKS_DIR ]
then
  mkdir $BENCHMARKS_DIR
fi
checkout "$BENCHMARKS_DIR/AreWeFast" "https://github.com/charig/are-we-fast-yet.git" "master" "benchmarks"
checkout "$BENCHMARKS_DIR/Mate" "https://github.com/charig/som.git" "reflectiveCompiler" "Examples/Benchmarks/*;Smalltalk/*"
INFO Downloading MTG JSON data files 
pushd $BENCHMARKS_DIR/Mate/Examples/Benchmarks/Mate/Tracing/ 
download_zip "AllSets-x.json.zip" "https://mtgjson.com/json/AllSets-x.json.zip"
download_zip "AllSets.json.zip" "https://mtgjson.com/json/AllSets.json.zip"
python cleanJsonFile "AllSets-x"
python cleanJsonFile "AllSets"
popd
$SCRIPT_PATH/makeBenchmarks.sh

OK TruffleMATE Build Completed.