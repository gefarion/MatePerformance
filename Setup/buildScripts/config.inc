#!/bin/bash

# make SCRIPT_PATH absolute
pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd`
popd > /dev/null

#set pypy and java wich jvmci enabled dirs manually
PYPY_DIR="/Users/guidochari/.local/pypy2-v6.0.0-src"

if [ -z $ROOT_PATH ]
then
  ROOT_PATH="$SCRIPT_PATH/.."
fi

IMPLEMENTATIONS_PATH=$ROOT_PATH/Implementations
DATA_DIR=$ROOT_PATH/Data
BENCHMARKS_DIR=$ROOT_PATH/Benchmarks

## GraalVM Binary
export GRAAL_VM_CMD=$IMPLEMENTATIONS_PATH/graalvm/bin/java
export GRAAL_JS=$IMPLEMENTATIONS_PATH/graalvm/bin/node
