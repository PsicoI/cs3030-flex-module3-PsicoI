#!/bin/bash

cat /etc/passwd | grep -v -e "nologin\|false" | wc -l

