#!/bin/bash
Input_file="$1"
capitalized_file="${1%.*}-U.txt"

if [[ $# -ne 1 ]]; then
    echo "ERROR: no file specified $0"
    exit 2
fi
sed 's/\<god\>/God/Ig' "$Input_file" > "$capitalized_file"

echo "Capitalized version saved to: $capitalized_file"
echo "Done!"