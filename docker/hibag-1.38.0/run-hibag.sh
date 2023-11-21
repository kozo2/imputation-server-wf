#!/bin/bash

# Usage
usage(){
    echo "Usage: "
    echo "CMD <input-binary-PLINK-file-prefix> <output-prefix> <model>"
}

if [ $# -ne 3 ] ; then
    usage
    exit
fi

# Set variables
in=$1
out=$2
model=$3

SCRIPT_DIR="`pwd`"

# Run HIBAG
if [ ! -f $out ] ; then
    echo ""
    echo "-------------------------------------------------------"
    echo "Run HIBAG: "
    (/usr/bin/time /opt/run-hibag.pl \
                   -i $in \
                   -o $out \
                   -m $model ) \
        2>&1 | tee $out.log
    echo "-------------------------------------------------------"
    echo ""
fi
