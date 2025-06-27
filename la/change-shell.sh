#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "ERROR: Please specify a file Usage: $0 <filename>"
    exit 1
fi
sed -i.bk s/bash/zsh/ ${1}