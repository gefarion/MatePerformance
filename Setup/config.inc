#!/bin/bash
CONFIG_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [ -z $ROOT_PATH ]
then
  ROOT_PATH="$CONFIG_PATH/.."
fi

#set pypy and java wich jvmci enabled dirs manually
PYPY_DIR="/home/guido/Documents/Projects/pypy"
#PYPY_DIR="/Users/guidochari/.local/pypy2-v6.0.0-src"

# Directories
SETUP_DIR="$ROOT_PATH/Setup"
IMPLEMENTATIONS_DIR="$ROOT_PATH/Implementations"
DATA_DIR="$ROOT_PATH/Data"
BENCHMARKS_DIR="$ROOT_PATH/Benchmarks"
BUILDSCRIPTS_DIR="$SETUP_DIR/BuildScripts"
TRUFFLE_MATE_DIR="$IMPLEMENTATIONS_DIR/TruffleMate"
RTRUFFLE_MATE_DIR="$IMPLEMENTATIONS_DIR/RTruffleMate"
PHARO_DIR="$IMPLEMENTATIONS_DIR/Pharo"

# Repositories
TRUFFLEMATE_REPO_URL="https://github.com/charig/TruffleMATE.git"
RTRUFFLEMATE_REPO_URL="https://github.com/charig/RTruffleMATE.git"
MATE_IMPL_INSHAPE_NAME="EnvironmentInShape"
MATE_IMPL_INOBJECT_NAME="EnvironmentInObject"

# Environment settings for compiling
#JAVA_HOME_TRUFFLE="/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home"
JAVA_HOME_TRUFFLE="/usr/lib/jvm/java-11-oracle/"
