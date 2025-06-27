#!/usr/bin/env bash

# function hello
# function hello()
hello()
{
name=$1
number=$2
 echo "Hello $1 from function inside $0 [$number]"
}

echo "Hello from file"
# Main code here
# call function
hello "Waldo"
hello "Cody" 987

exit 0
