#!/usr/bin/env bash
# Copyright, 2022, Warren McHugh <neowazza@gmail.com>
#
# The requirements for this script asked it to be called `roulette_dealer_finder_by_time_and_game.sh`
# but it doesn't just fin the roulette dealer, so this is a terrible name for this script!
#
# Also, the question suggested that this script is for future use of schedules, so where
# should this script be kept? Step 2 asked us to already MOVE files out of the Dealer_Schedules_0310
# so where should this script be? In the Delaer_schedules_0310 or in the Dealer_Analysis folder?
# Or should it be in the root of the project folder and recursively search all the subdirectories
# looking for the dealer schedule files?


err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

usage() {
    echo "Usage: $0 <game> <date> <hour> [meridiem]"
    echo "Extracts the time, meridiem, first and last names of the dealer from dealer schedules."
    echo
    echo -e "\t<game>\t\tGame of the schedule. Must be either BJ=Black Jack, ROU=Roulette or TH=Texas Hold'em. Required."
    echo -e "\t<date>\t\tDate of the schedule in the format MMDD. Required."
    echo -e "\t<hour>\t\tHour of the schedule in the format HH. Must be between 00 and 12, and be exactly 2 digits long. Required."
    echo -e "\t[meridiem]\tMeridiem of the schedule. Must be either AM or PM. Optional."
    exit 1
}

# Put the variables into something easier to work with
GAME=$(echo $1 | tr '[:lower:]' '[:upper:]') # Make sure we normalise to upper case
DATE=$2
HOUR=$3
MERIDIEM=$(echo $4 | tr '[:lower:]' '[:upper:]') # Make sure we normalise to upper case

# Test the number of arguments is either 2 or 3
if [ $# -ne 3 ] && [ $# -ne 4 ]; then
    usage
    exit 1
fi

# Assert the game is supported
if ! [[ $GAME =~ ^(BJ|ROU|TH)$ ]]; then
    err "The game is not supported."
    echo
    usage
    exit 2
fi

# Assert the date is in the correct format MMDD (format only, not that it is a valid date)
if ! [[ $DATE =~ ^(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])$ ]]; then
    err "The date is not in the correct format MMDD."
    echo
    usage
    exit 3
fi

# Set the correct file and see if it exists
FILE=${DATE}_Dealer_schedule
if [ ! -f $FILE ]; then
    err "The schedule file '$FILE' for the date $DATE does not exist."
    echo
    usage
    exit 4
fi

# Check the hour is in the correct 12 hour format
if ! [[ $HOUR =~ ^(0[1-9]|1[0-2])$ ]]; then
    err "The hour is not in the correct format HH."
    echo
    usage
    exit 5
fi

# If the meridiem is provided, check it is in the correct format
if [ $# -eq 4 ]; then
    if ! [[ $MERIDIEM =~ ^(AM|PM)$ ]]; then
        err "The meridiem is not in the correct format AM or PM."
        echo
        usage
        exit 6
    fi
fi

# Define the filter
FILTER="$HOUR:00:00 $MERIDIEM"

# Case based on the game chosen
case $GAME in
    BJ)
        # Find the Black Jack Dealer
        DEALER='$3 "\t" $4'
        ;;
    ROU)
        # Find the Roulette Dealer
        DEALER='$5 "\t" $6'
        ;;
    TH)
        # Find the Texas Hold'em Dealer
        DEALER='$7 "\t" $8'
        ;;
esac

# Compile the AWK program
AWK_PROGRAM="{print \$1 \"\\t\" \$2 \"\\t\" $DEALER}"

# And finally output the data
grep "$FILTER" $FILE | awk "$AWK_PROGRAM"
