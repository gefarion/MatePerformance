#!/bin/bash

#set pypy and java wich jvmci enabled dirs manually
PYPY_DIR="/Users/guidochari/.local/pypy2-v6.0.0-src"

# Directories
IMPLEMENTATIONS_PATH=$BASE_DIR/Implementations
DATA_DIR=$BASE_DIR/Data
BENCHMARKS_DIR=$BASE_DIR/Benchmarks
BUILDSCRIPTS_DIR=$BASE_DIR/buildScripts
TRUFFLE_MATE_DIR=$IMPLEMENTATIONS_PATH/TruffleMate
RTRUFFLE_MATE_DIR=$IMPLEMENTATIONS_PATH/RTruffleMate

## Repositories
TRUFFLEMATE_REPO_URL="https://github.com/charig/TruffleMATE.git"
RTRUFFLEMATE_REPO_URL="https://github.com/charig/RTruffleMATE.git"
MATE_IMPL_INSHAPE_NAME="EnvironmentInShape"
MATE_IMPL_INOBJECT_NAME="EnvironmentInShape"

## Environment settings for compiling
JAVA_HOME_TRUFFLE="/usr/lib/jvm/java-11-oracle/"
