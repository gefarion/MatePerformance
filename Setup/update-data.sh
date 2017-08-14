#!/bin/bash
set -e # make script fail on first error
SCRIPT_PATH=`dirname $0`

if [ ! "$1" = "guido@mostaza.cuartos.inv.dc.uba.ar" ]
then
    BUILDSCRIPTS=$SCRIPT_PATH/buildScripts
    source $BUILDSCRIPTS/basicFunctions.inc
    source $BUILDSCRIPTS/config.inc
else
    MOSTAZA_ROOT_PATH='Documents/Projects/MatePerformance/Setup'
    MOSTAZA_DATA_PATH=$MOSTAZA_ROOT_PATH/../Data
fi

date=`date "+%d-%m-%y"`
name="experiments$date.tar.gz" 

prepare_data() {
    INFO Moving data from $ROOT_PATH to $DATA_DIR
    pushd $SCRIPT_PATH
    for file in *.data; do
        if [ ! -e $file ]
        then
            break
        fi
        mv "$file" "$DATA_DIR/$file"
    done
    popd > /dev/null
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

