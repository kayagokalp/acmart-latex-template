#!/bin/bash

# If there are errors with any command executed here, exit with non-zero code.
set -e

# Define BASEDIR as the directory where the script is located
BASEDIR=$(dirname "$0")

OUTDIR="$BASEDIR/out"
AUXDIR="$OUTDIR/aux"

# Check if OUTDIR exists; if not, create it
if [ ! -d "$OUTDIR" ]; then
    mkdir -p "$OUTDIR"
fi

pdflatex -interaction=nonstopmode -output-directory="$OUTDIR" "$BASEDIR/src/main.tex"

# Check if AUXDIR exists; if not, create it
if [ ! -d "$AUXDIR" ]; then
    mkdir -p "$AUXDIR"
fi

# Move all files that are not .pdf from OUTDIR to AUXDIR
find "$OUTDIR" -type f ! -name "*.pdf" -exec mv {} "$AUXDIR" \;
