#!/bin/bash
SCRIPT_PATH=`dirname $0`
pushd Setup
exec sudo rebench -d mate.conf "$@"
popd /dev/null