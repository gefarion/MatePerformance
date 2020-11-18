#!/bin/bash
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

ALL=false

if [ "$1" == "All" ]
then
    ALL=true
    shift
fi

if [[
    "$ALL" == true
    || "$1" == "AreWeFast"
    || "$1" == "Inherent"
    || "$1" == "IndividualActivations"
    || "$1" == "Readonly"
    || "$1" == "ReadonlyAwf"
    || "$1" == "Tracing"
    || "$1" == "ReflectiveCompilation"
    || "$1" == "Baseline"
   ]]
then
    set -e # make script fail on first error
#    systemctl stop gdm
#    systemctl stop cron
#    systemctl stop ondemand
    docker run --privileged=true -v "$SCRIPT_PATH/Data:/Data" -v "$SCRIPT_PATH/Conf:/Conf" mate_dardo \
        /opt/MatePerformance/Scripts/runBenchs.sh /Conf/mate.conf /Data /opt/Benchmarks/AreWeFast/ /opt/Som/ /opt/TruffleMate/ /opt/RTruffleMate/MOInShape/ /opt/RTruffleMate/MOInObject /opt/Pharo /opt/graal \
        $@
fi



