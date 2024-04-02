#!/bin/bash

STR="$@"
OUT=$(echo $STR | awk '{print $1;}')
IN=$(echo $STR | awk '{$1= ""; print $0}' | xargs)
if [ -f $OUT ]; then
    TERMINATE="\0"
    while [ "$TERMINATE" != "y" -a "$TERMINATE" != "n" ]; do
    printf "[ \033[33;1mWARNING\033[0m ] output will overwrite existing file \'$OUT\', proceed?(y,n) "
    read TERMINATE
    if [ "$TERMINATE" = "n" ]; then
        exit 0
    fi
    done
fi
gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$OUT $IN
