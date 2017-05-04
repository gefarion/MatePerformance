#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
if [ ! "$1" = "guido@mostaza.cuartos.inv.dc.uba.ar" ]
then
    BUILDSCRIPTS=$SCRIPT_PATH/buildScripts
    source $BUILDSCRIPTS/basicFunctions.inc

    export ROOT_PATH=$SCRIPT_PATH

    source $BUILDSCRIPTS/config.inc

    ROOT_PATH='Documents/Writings/Research/optimizing-reflective-execution-environments/Experiments/Setup/'
    DATA_PATH=$ROOT_PATH/../Data
fi



date=`date "+%d-%m-%y"`
name="experiments$date.tar.gz" 

prepare_data() {
    INFO Moving data from $ROOT_PATH to $DATA_DIR
    for file in *.data; do
        mv "$file" "$DATA_DIR/$file"
    done
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
        ssh gchari@zorzal.dc.uba.ar 'bash -s' < $SCRIPT_PATH/$0 "guido@mostaza.cuartos.inv.dc.uba.ar"
        scp "gchari@zorzal.dc.uba.ar:$name" $DATA_DIR/
    else
        ssh "guido@mostaza.cuartos.inv.dc.uba.ar" "bash $ROOT_PATH/update-data.sh"
        scp "guido@mostaza.cuartos.inv.dc.uba.ar:$DATA_PATH/name" .
    fi    
else
    prepare_data
fi

