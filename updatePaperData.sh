#!/bin/bash
pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd`
popd > /dev/null

PAPER_PATH=$SCRIPT_PATH/../../Escritos/Research/optimizing-reflective-execution-environments/ 
TESIS_PATH=$SCRIPT_PATH/../../Escritos/Research/TesisPhd/

cp Report/images/*.pdf $PAPER_PATH/images/
cp Report/images/*.pdf $TESIS_PATH/Imagenes/
cp Report/experiments.tex $PAPER_PATH/sections/experiments.tex
cp Report/experiments.tex $TESIS_PATH/Secciones/experiments.tex

SUBS="\/"
SCRIPT_PATH_ESCAPED=${SCRIPT_PATH////$SUBS}

IMAGES_PATH="$SCRIPT_PATH_ESCAPED\/Report\/images"
PAPER_IMAGES_PATH="\.\.\/images"
TESIS_IMAGES_PATH="\.\.\/Imagenes"

sed -i -e "s/$IMAGES_PATH/$PAPER_IMAGES_PATH/g" $PAPER_PATH/sections/experiments.tex
sed -i -e "s/$IMAGES_PATH/$TESIS_IMAGES_PATH/g" $TESIS_PATH/Secciones/experiments.tex