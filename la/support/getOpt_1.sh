#!/usr/bin/env bash

while getopts 'wsu' OPTION; do
  case "$OPTION" in 
    w) 
      echo "Option w used" ;;

    s)
      echo "Option s used"
      ;;

    u)
      echo "Option u used"
      ;;

    ?) 
      echo "Usage: $(basename $0) [-w] [-u] [-s]"
      exit 1
      ;;
  esac
done

exit 0
