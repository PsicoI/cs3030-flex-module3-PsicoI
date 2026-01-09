#!/bin/bash
# grep -v checks for inverted match
# grep -e checks for regular expressions
cat /etc/passwd | grep -v -e "nologin\|false" | wc -l

