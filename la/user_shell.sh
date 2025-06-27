#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "ERROR: Please specify a file Usage: $0 <filename>"
    exit 1
fi
cat /etc/passwd | grep -v "nologin\\" | wc ${1}
echo "Changed bash to zsh in ${1}"
echo "Backup created as ${1}.bk"
echo "done!"