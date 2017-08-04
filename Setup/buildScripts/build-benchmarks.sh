#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build Benchmarks
if [ "$1" = "style" ]
then
  exit 0
else
  if [ ! -d $BENCHMARKS_DIR ]
  then
    mkdir $BENCHMARKS_DIR
  fi
  checkout $ROOT_PATH/Benchmarks/AreWeFast "https://github.com/smarr/are-we-fast-yet.git" "master" "benchmarks"
  checkout "$BENCHMARKS_DIR/Mate" "https://github.com/charig/som.git" "reflectiveCompiler" "Examples/Benchmarks/*;Smalltalk/*"
  INFO Downloading MTG JSON data files 
  pushd $BENCHMARKS_DIR/Mate/Examples/Benchmarks/Mate/Tracing/ 
  download_zip "AllSets-x.json.zip" "https://mtgjson.com/json/AllSets-x.json.zip"
  download_zip "AllSets.json.zip" "https://mtgjson.com/json/AllSets.json.zip"
  python cleanJsonFile "AllSets-x"
  python cleanJsonFile "AllSets"
  popd
  $SCRIPT_PATH/makeBenchmarks.sh
fi
OK TruffleMATE Build Completed.
