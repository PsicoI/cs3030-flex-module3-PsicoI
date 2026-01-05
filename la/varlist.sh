#!/usr/bin/env bash
# This just echos three collected variables gathered from the user

echo "Var one [$1]"
echo "Var two [$2]"
echo "Var three [$3]"

echo "[$@]"
for var in "$@"
do
    echo $var
done

exit 0