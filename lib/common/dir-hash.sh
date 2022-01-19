#!/bin/bash

set -Ceu

name=$1
base_path=$2
num=$3

hash_path=$base_path.$num.hash

(
    cd $HOME/$name
    if (( $(ls $base_path.*.hash 2>/dev/null | wc -l) == 0 )); then
        touch $base_path.hash.v3
    fi
    if [[ -f $base_path.hash.v3 ]]; then
        find . | LC_ALL=C sort
        find . -type f | xargs cat | sha1sum | cut -b-40
    elif [ -f $HOME/.mydocker2/archive/hash-v2 ]; then
        find . -type f | LC_ALL=C sort | while read path; do
            echo $path
            if [ -f "$path" ]; then
                cat "$path"
            fi
            echo
        done | sha1sum | cut -b-40
    else
        find . -type f | LC_ALL=C sort | while read path; do
            echo $path
            if [ -f "$path" ]; then
                cat "$path" | sha1sum | cut -b-40
            fi
        done
    fi
) >| $hash_path.txt
cat $hash_path.txt | sha1sum | cut -b-40 >| $hash_path

