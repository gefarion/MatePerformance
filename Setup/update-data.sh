#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`
BUILDSCRIPTS=$SCRIPT_PATH/buildScripts
source $BUILDSCRIPTS/basicFunctions.inc

export ROOT_PATH=$SCRIPT_PATH

source $BUILDSCRIPTS/config.inc

MOSTAZA_ROOT_PATH='Documents/Writings/Research/optimizing-reflective-execution-environments/Experiments/Setup/'
MOSTAZA_DATA_PATH=$MOSTAZA_ROOT_PATH/../Data

date=`date "+%d-%m-%y"`
name="experiments$date.tar.gz" 

prepare_data() {
    INFO Compressing data into name
    tar -czvf $name *.data
    OK done
    INFO Moving data to $DATA_DIR
    for file in *.data; do
        mv "$file" "$DATA_DIR/$file"
    done
    mv $name $DATA_DIR/$name
    OK done
}

if [ ! -z $1]
then
    if [ "$1" = "zorzal"]
    then
        ssh gchari@zorzal.dc.uba.ar 'bash -s' < $SCRIPT_PATH/$0 "guido@mostaza.cuartos.inv.dc.uba.ar"
        scp "gchari@zorzal.dc.uba.ar:$name" $DATA_DIR/
    else
        ssh "guido@mostaza.cuartos.inv.dc.uba.ar" 'bash -s' < "$MOSTAZA_ROOT_PATH/update-data.sh"
        scp "guido@mostaza.cuartos.inv.dc.uba.ar:$MOSTAZA_DATA_PATH/name" .
    fi    
else
    prepare_data
fi

