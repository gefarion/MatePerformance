#!/bin/bash
#set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/basicFunctions.inc
source $SCRIPT_PATH/config.inc

INFO Build TruffleMATE
if [ "$1" = "style" ]
then
  exit 0
else
  checkout $ROOT_PATH "https://github.com/smarr/are-we-fast-yet.git" "master" "benchmarks"
  checkout "$BENCHMARKS_DIR/Mate" "https://github.com/charig/som.git" "reflectiveCompiler" "Examples/Benchmarks/*;Smalltalk/*"
  INFO Downloading MTG JSON data files 
  pushd $BENCHMARKS_DIR/Mate/Examples/Benchmarks/Mate/Tracing/ 
  if [ ! -f "AllSets-x.json.zip" ]
  then
    get_web_getter 
    $GET "https://mtgjson.com/json/AllSets-x.json.zip"
  fi
  unzip AllSets-x.json.zip
  rm AllSets-x.json.zip
  python cleanJsonFile
  popd
  $SCRIPT_PATH/makeBenchmarks.sh
fi
OK TruffleMATE Build Completed.
