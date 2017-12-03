#!/bin/bash
pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd`
popd > /dev/null

if [ -d $SCRIPT_PATH/../../Writing ]
then
    PAPER_PATH=$SCRIPT_PATH/../../Writing/Research/mateonwards/
else
    PAPER_PATH=$SCRIPT_PATH/../../../Escritos/Research/mateonwards/
fi

cp images/*.pdf $PAPER_PATH/images/
cp experiments.tex $PAPER_PATH/sections/experiments.tex

SUBS="\/"
SCRIPT_PATH_ESCAPED=${SCRIPT_PATH////$SUBS}

IMAGES_PATH="$SCRIPT_PATH_ESCAPED\/images"
PAPER_IMAGES_PATH="Images"

sed -i -e "s/$IMAGES_PATH/$PAPER_IMAGES_PATH/g" $PAPER_PATH/sections/experiments.tex
