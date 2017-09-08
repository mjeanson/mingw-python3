#!/bin/bash

set -eu

FILE_LIST="$(find out -name "*.exe" -or -name "*.dll")"

for file in $FILE_LIST; do
  #echo "## $file"
  MINGW_BUNDLEDLLS_SEARCH_PATH="$HOME/mingw-python3/out/mingw64/bin:$PATH" python mingw-bundledlls.py $file
done
