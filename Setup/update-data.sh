#!/bin/bash
set -e # make script fail on first error

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi



if [ ! "$1" = "guido@mostaza.cuartos.inv.dc.uba.ar" ]
then
    source "$SCRIPT_PATH/BuildScripts/basicFunctions.inc"
else
    MOSTAZA_ROOT_PATH='Documents/Projects/mateperformance/Setup'
    MOSTAZA_DATA_PATH=$MOSTAZA_ROOT_PATH/../Data
fi

date=`date "+%d-%m-%y"`
name="experiments$date.tar.gz" 

prepare_data() {
    pushd $DATA_DIR
    INFO Compressing data into $name
    tar -czvf $name *.data
    popd > /dev/null
    OK done
}

if [ $# -eq 1 ]
then
    if [ "$1" = "zorzal" ]
    then
        ssh gchari@zorzal.dc.uba.ar 'bash -s' < "$SCRIPT_PATH/$(basename $0)" "guido@mostaza.cuartos.inv.dc.uba.ar"
        scp "gchari@zorzal.dc.uba.ar:$name" "$DATA_DIR/$name"
        ssh gchari@zorzal.dc.uba.ar "rm $name"
        pushd $DATA_DIR
        INFO Uncompressing $name
        tar -zxvf $name 
        popd > /dev/null
        OK done
    else
        ssh "$1" "bash $MOSTAZA_ROOT_PATH/update-data.sh"
        scp "$1:$MOSTAZA_DATA_PATH/$name" .
    fi    
else
    prepare_data
fi

