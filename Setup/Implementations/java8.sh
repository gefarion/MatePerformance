#!/bin/bash
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/../buildScripts/config.inc
exec $JAVA8_HOME/bin/java "$@"