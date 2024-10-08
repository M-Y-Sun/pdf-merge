#!/bin/bash

STR="$*"
OUT=$(echo "$STR" | awk '{print $1;}')
IN=$(echo "$STR" | awk '{$1= ""; print $0}' | xargs)
if [ -f "$OUT" ]; then
    TERMINATE="\0"
    while [ "$TERMINATE" != "Y" ] && [ "$TERMINATE" != "n" ]; do
        printf "[ \033[33;1mWARNING\033[0m ] output will overwrite existing file \'%s\', proceed?(Y,n) " "$OUT"
        read -r TERMINATE
        if [ "$TERMINATE" = "n" ]; then
            exit 0
        fi
    done
fi

gs -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$OUT $IN
