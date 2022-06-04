#!/usr/bin/env bash
# Copyright, 2022, Warren McHugh <neowazza@gmail.com>

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

usage() {
    echo "Usage: $0 <date> <hour> [meridiem]"
    echo "Extracts the time, meridiem, first and last names of the roulette dealer from dealer schedules."
    echo
    echo -e "\t<date>\t\tDate of the schedule in the format MMDD. Required."
    echo -e "\t<hour>\t\tHour of the schedule in the format HH. Must be between 00 and 12, and be exactly 2 digits long. Required."
    echo -e "\t[meridiem]\tMeridiem of the schedule. Must be either AM or PM. Optional."
    exit 1
}

# Put the variables into something easier to work with
DATE=$1
HOUR=$2
MERIDIEM=$(echo $3 | tr '[:lower:]' '[:upper:]') # Make sure we normalise to upper case

# Test the number of arguments is either 2 or 3
if [ $# -ne 2 ] && [ $# -ne 3 ]; then
    usage
    exit 1
fi

# Assert the date is in the correct format MMDD (format only, not that it is a valid date)
if ! [[ $DATE =~ ^(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])$ ]]; then
    err "The date is not in the correct format MMDD."
    echo
    usage
    exit 2
fi

# Set the correct file and see if it exists
FILE=${DATE}_Dealer_schedule
if [ ! -f $FILE ]; then
    err "The schedule file '$FILE' for the date $DATE does not exist."
    echo
    usage
    exit 3
fi

# Check the hour is in the correct 12 hour format
if ! [[ $HOUR =~ ^(0[1-9]|1[0-2])$ ]]; then
    err "The hour is not in the correct format HH."
    echo
    usage
    exit 4
fi

# If the meridiem is provided, check it is in the correct format
if [ $# -eq 3 ]; then
    if ! [[ $MERIDIEM =~ ^(AM|PM)$ ]]; then
        err "The meridiem is not in the correct format AM or PM."
        echo
        usage
        exit 5
    fi
fi

# Define the filter
FILTER="$HOUR:00:00 $MERIDIEM"

# And finally output the data
grep "$FILTER" $FILE | awk '{print $1 "\t" $2 "\t" $5 "\t" $6}'
