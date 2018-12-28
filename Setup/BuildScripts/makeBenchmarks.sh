#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

BUILDSCRIPTS="$SCRIPT_PATH"
source "$BUILDSCRIPTS/basicFunctions.inc"

INFO Building Benchmarks
# JAVA
buildBench "Java" "$BENCHMARKS_DIR/AreWeFast/benchmarks/Java" "ant jar"

#buildBench Crystal $BENCHMARKS_DIR/AreWeFast/benchmarks/Crystal "build.sh"

# PHARO
INFO Build Pharo Benchmarking Image
pushd $BENCHMARKS_DIR/AreWeFast/benchmarks/Smalltalk
cp $PHARO_DIR/Pharo.image .
$PHARO_DIR/pharo Pharo.image build-image.st
mv AWFY.image AWFY_Pharo.image
mv AWFY.changes AWFY_Pharo.changes
rm $BENCHMARKS_DIR/AreWeFast/benchmarks/Smalltalk/Pharo.image
rm $BENCHMARKS_DIR/AreWeFast/benchmarks/Smalltalk/Pharo.changes
popd > /dev/null
OK Benchmarks Build Completed.
