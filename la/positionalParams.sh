#!/usr/bin/env bash

help()
{
    echo "Missing required params"
    echo "Sample usage: $0 <PARAM1> <PARAM2> <PARAM3>"
}
# Requires 3 input params, $# == the total number of parameters called in program
echo "Total input positional params [$#]"
if [[ $# -eq 3 ]]; then
    echo "First[$1], second[$2], third[$3]"
else
    help
    exit 1
fi

echo "Good to go"

exit 0