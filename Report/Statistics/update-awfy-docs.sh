#!/bin/sh

../scripts/knit.R metrics.Rmd
cp -R figures metrics.md ../../are-we-fast-yet/docs/
