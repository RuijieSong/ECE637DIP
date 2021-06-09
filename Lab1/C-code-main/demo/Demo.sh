#!/bin/bash

../bin/ImageReadWriteExample img03.tif
# mv green.tif output5
mv color.tif output5

../bin/SurrogateFunctionExample > output5/data.txt

# Run this matlab script to plot the data
# matlab PlotData.m

