#!/usr/bin/env bash

echo "Var one [$1]"
echo "Var two [$2]"
echo "Var three [$3]"

echo "[$@]"
for var in "$@"
do
    echo $var
done

exit 0