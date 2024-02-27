#!/bin/bash

str="$@"
out=$(echo $str | awk '{print $1;}')
in=$(echo $str | awk '{$1= ""; print $0}' | xargs)
if [ -f $out ]; then
    terminate="\0"
    while [ "$terminate" != "y" -a "$terminate" != "n" ]; do
    printf "\033[33;1mWARNING\033[0m: output file will overwrite existing file \'$(find $(cd ..; pwd) -name $out)\', proceed?(y,n) "
    read terminate
    if [ "$terminate" = "n" ]; then
        exit 0
    fi
    done
fi
gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$out $in
