#!/usr/bin/awk -f
awk -v OFS="," -F"," -f programas.AWK/$1.awk $2 
