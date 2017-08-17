#!/bin/bash
SCRIPT_PATH=`dirname $0`

PAPER_PATH=$SCRIPT_PATH/../../Escritos/Research/optimizing-reflective-execution-environments/ 
cp Report/images/*.pdf $PAPER_PATH/images/
cp Report/experiments.tex $PAPER_PATH/sections/experiments.tex