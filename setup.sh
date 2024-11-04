#!/bin/bash

# Search package from file: 
# tlmgr search --global --file <FILENAME.sty>

# Loop through each line in the package file and install the package
while IFS= read -r package; do
  sudo tlmgr install "$package"
done < latex-packages
