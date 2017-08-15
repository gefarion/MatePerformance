#!/bin/bash

# make SCRIPT_PATH absolute
pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd`
popd > /dev/null
## Graal-Core Binary
##  folder is different depending on host JDK version
##  take the first, might pick up outdated version unfortunately
#GRAAL_CORE_CMD=`find $SCRIPT_PATH -type f -name java | grep "product/bin/" | head -n 1`

if [ -z $ROOT_PATH ]
then
  ROOT_PATH="$SCRIPT_PATH/.."
fi

IMPLEMENTATIONS_PATH=$ROOT_PATH/Implementations

DATA_DIR=$ROOT_PATH/Data

#GRAAL_HOME=$IMPLEMENTATIONS_PATH/graalvm
GRAAL_CORE_CMD=/home/guido/Documents/Projects/GraalBasic/graal-jvmci-8/jdk1.8.0_101/product/bin/java

GRAAL_HOSTED_FLAGS="-server -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -d64 "
GRAAL_JIT_FLAGS="-server -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler -d64 "

BENCHMARKS_DIR=$ROOT_PATH/Benchmarks

#set pypy and java wich jvmci enabled dirs manually
PYPY_DIR=""
JAVA_JVMCI_DIR=""

## GraalVM Binary
export GRAAL_VM_CMD=$IMPLEMENTATIONS_PATH/graalvm/bin/java
export GRAAL_JS=$IMPLEMENTATIONS_PATH/graalvm/bin/node

export RBX_314_CMD=/home/guido/Documents/Projects/rubinius/3.69/bin/rbx

if [ -x /usr/libexec/java_home ]   # usually on OS X, this tool is available
then
  export OS=mac
  export JAVA8_HOME=`/usr/libexec/java_home -v 1.8`  
elif [ -x /usr/sbin/update-java-alternatives ]
then
  export OS=linux
  jvm_info=(`/usr/sbin/update-java-alternatives -l | grep java-8`)

## Needed if using openjdk
  if [ -z "${jvm_info[2]}" ]
  then
   jvm_info=(`/usr/sbin/update-java-alternatives -l | grep java-1.8`)
  fi

  export JAVA8_HOME=${jvm_info[2]}
else
  WARN Java directories could not be guessed, please check config.inc
fi
if [ ! -d "$JAVA8_HOME" ]
then
  ERR "Java 8 was not found. Please check config.inc file"
  exit 1
fi

export JRUBY_CMD=$SCRIPT_PATH/JRuby/bin/jruby

function home_from_command() {
  HOME=`dirname $1`
  HOME=`dirname $HOME`
  HOME=`dirname $HOME`
  HOME=`dirname $HOME`
}

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}
