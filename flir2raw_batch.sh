#!/bin/bash

for jpg in $1/*.jpg
do
  echo "Processing $jpg"
  flir2raw.R $jpg
done
