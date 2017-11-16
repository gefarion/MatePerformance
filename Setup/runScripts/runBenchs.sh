#!/bin/bash
SCRIPT_PATH=`dirname $0`
exec sudo env "PATH=$PATH" rebench -d mate.conf "$@"
popd /dev/null