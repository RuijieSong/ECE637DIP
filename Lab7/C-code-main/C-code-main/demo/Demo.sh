#!/bin/bash

../bin/ImageReadWriteExample img14sp.tif
# mv green.tif output5
mv output.tif output5

../bin/SurrogateFunctionExample > output5/data.txt

# Run this matlab script to plot the data
# matlab PlotData.m

