#!/usr/bin/env bash
# Copyright, 2022, Warren McHugh <neowazza@gmail.com>

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

usage() {
    echo "Usage: $0 <file>"
    echo "Extracts the time, meridiem, first and last names of the roulette dealer from the input file."
    exit 1
}

if [ $# -ne 1 ]; then
    err "Invalid number of arguments."
    usage
fi

if [ ! -f "$1" ]; then
    err "File '$1' does not exist."
fi

INPUT_FILE="$1"
awk '{ print $1"\t"$2"\t"$5"\t"$6 }' "$INPUT_FILE"

