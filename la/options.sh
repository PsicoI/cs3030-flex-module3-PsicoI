#!/usr/bin/env bash
optstring=":wsu:"
while getopts ${optstring} OPTION; do
  case "$OPTION" in 
    w) 
      echo "Option w used" ;;

    s)
      echo "Option s used"
      ;;

    u)
    university="#OPTARG"
      echo "Option u used with $university"
      ;;
    

    ?) 
      echo "Usage: $(basename $0) [-w] [-u ARG] [-s]"
      exit 1
      ;;
  esac
done

echo "Before - variable one is : $1"
shift "$(($OPTIND -1))"
echo "After - variable one is: $1"

exit 0
